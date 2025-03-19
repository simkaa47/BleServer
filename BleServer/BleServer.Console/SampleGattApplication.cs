using DotnetBleServer.Core;
using DotnetBleServer.Gatt;
using DotnetBleServer.Gatt.Description;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BleServer.Console
{
    class SampleGattApplication
    {
        public static async Task RegisterGattApplication(ServerContext serverContext)
        {
            var gattServiceDescription = new GattServiceDescription
            {
                UUID = "12345678-1234-5678-1234-56789abcdef0",
                
                Primary = true
            };

            var gattCharacteristicDescription = new GattCharacteristicDescription
            {
                CharacteristicSource = new ExampleCharacteristicSource(),
                UUID = "12345678-1234-5678-1234-56789abcdef1",
                Flags = new[] { "read", "write", "writable-auxiliaries" }
            };
            var gattDescriptorDescription = new GattDescriptorDescription
            {
                Value = new[] { (byte)'t' },
                UUID = "12345678-1234-5678-1234-56789abcdef2",
                Flags = new[] { "read", "write" }
            };
            var gab = new GattApplicationBuilder();
            gab
                .AddService(gattServiceDescription)
                .WithCharacteristic(gattCharacteristicDescription, new[] { gattDescriptorDescription });

            await new GattApplicationManager(serverContext).RegisterGattApplication(gab.BuildServiceDescriptions());
        }
        internal class ExampleCharacteristicSource : ICharacteristicSource
        {


            public Task WriteValueAsync(byte[] value)
            {
                System.Console.WriteLine("Writing value"); // Added System. prefix
                return Task.Run(() => System.Console.WriteLine(Encoding.ASCII.GetChars(value))); // Added System. prefix
            }

            public Task<byte[]> ReadValueAsync()
            {
                System.Console.WriteLine("Reading value"); // Added System. prefix
                return Task.FromResult(Encoding.ASCII.GetBytes("Hello BLE"));
            }
        }
    }
}
