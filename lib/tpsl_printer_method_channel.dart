import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tpsl_printer_platform_interface.dart';

/// An implementation of [TpslPrinterPlatform] that uses method channels.
class MethodChannelTpslPrinter extends TpslPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tpsl_printer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
