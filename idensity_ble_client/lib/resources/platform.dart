import 'dart:io';

/// True only on embedded Linux running in DRM/kiosk mode (no desktop environment).
/// On Android, Windows, or Linux with a DE — the system IME / physical keyboard is used.
bool get kShowOsk {
  // Debug override: flutter run --dart-define=FORCE_OSK=true
  const forceOsk = bool.fromEnvironment('FORCE_OSK', defaultValue: false);
  if (forceOsk) return true;
  if (!Platform.isLinux) return false;
  final de = Platform.environment['DE'] ?? '';
  return de != 'with';
}
