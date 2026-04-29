# Spectrum data flow: BLE characteristic → charts

## Two-level reassembly

BLE GATT MTU ≈ 23 bytes (20 usable payload). A single spectrum frame is up to
8 × 1034 bytes, so two levels of reassembly are needed:

| Level | Trigger | Result |
|---|---|---|
| 1 — BLE chunks | Last byte of accumulated buffer == `0x23` (`#`) | One application packet |
| 2 — App packets | `packetNum >= count` (header field) | One complete `AdcFrame` |

## Full chain

```
BLE Characteristic (d973f2e3) notification
        │  onValueReceived fires per MTU chunk (~20 bytes)
        ▼
BleConnection._onSpectrumChunk(List<int> chunk)          [ble_connection.dart]
  • Accumulate into _bleBuffer
  • Wait until _bleBuffer.last == 0x23 ('#')
        │
        ▼
BleConnection._parsePacket(List<int> data)
  Header bytes [0..9] decoded as ASCII:
    [0..4]  type tag   *AOLV / *AML1 / *AML2 / *AML3
    [5..7]  count      total packets in this frame
    [8..9]  packetNum  1-based index of this packet
  Sequence check: packetNum == _nextPacketNum
  Sample decode: bytes[10..end-1], 2 or 4 bytes/sample (little-endian)
  If packetNum == 1 → clear _samples
  Append decoded samples to _samples
  If packetNum >= count → emit AdcFrame, reset state
        │
        ▼
_spectrumController (StreamController<AdcFrame>.broadcast())
        │
        ▼
BleConnection.spectrumStream  →  Connection.spectrumStream  [interface]
        │
        ▼
DeviceServiceImpl.addDevices()                         [device_service_impl.dart]
  _spectrumSubscriptions[device] = spectrumStream.listen(
    (frame) => device.updateAdcFrame(frame)
  )
        │
        ▼
Device.updateAdcFrame(AdcFrame frame)                  [device.dart]
  oscilloscope  → device.oscillogramma = frame.samples
  spectrum*     → device.spectrum      = frame.samples
  _adcFrameController.add(frame)
        │
        ▼
Device.adcFrameStream  [BehaviorSubject<AdcFrame>]
        │
        ▼
SpectrumMainWidget._chartPanel  StreamBuilder          [spectrum_main_widget.dart]
        │
        ├─ AdcFrameType.oscilloscope
        │    OscilloscopeChartWidget  — green FastLineSeries, X=index, Y=amplitude
        │
        └─ AdcFrameType.spectrum*
             SpectrumChartWidget      — blue  FastLineSeries, X=channel, Y=count
```

## AdcFrameType → packet header mapping

| Header tag | AdcFrameType | Packet count | Bytes/sample |
|---|---|---|---|
| `*AOLV` | `oscilloscope` | 1 | 2 |
| `*AML1` | `spectrumPartial` | 8 | 2 |
| `*AML2` | `spectrumFull` | 8 | 2 |
| `*AML3` | `counters` | 8 | 4 |

## Key files

| File | Role |
|---|---|
| `lib/models/adc/adc_frame.dart` | `AdcFrame` model + `AdcFrameType` enum |
| `lib/services/bluetooth/ble_connection.dart` | Two-level reassembly logic |
| `lib/services/ethernet/ethernet_connection.dart` | Stub — `Stream.empty()` (TODO: UDP server) |
| `lib/models/device.dart` | `adcFrameStream` BehaviorSubject, `updateAdcFrame` |
| `lib/services/device_service_impl.dart` | Wires `spectrumStream` → `device.updateAdcFrame` |
| `lib/widgets/device_settings/spectrum/spectrum_main_widget.dart` | Chart switcher UI |
| `lib/widgets/device_settings/spectrum/spectrum_chart_widget.dart` | Spectrum chart |
| `lib/widgets/device_settings/spectrum/oscilloscope_chart_widget.dart` | Oscilloscope chart |
