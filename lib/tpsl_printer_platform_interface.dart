import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tpsl_printer_method_channel.dart';

abstract class TpslPrinterPlatform extends PlatformInterface {
  /// Constructs a TpslPrinterPlatform.
  TpslPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static TpslPrinterPlatform _instance = MethodChannelTpslPrinter();

  /// The default instance of [TpslPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelTpslPrinter].
  static TpslPrinterPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TpslPrinterPlatform] when
  /// they register themselves.
  static set instance(TpslPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
