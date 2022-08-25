import 'package:flutter_test/flutter_test.dart';
import 'package:tpsl_printer/tpsl_printer.dart';
import 'package:tpsl_printer/tpsl_printer_platform_interface.dart';
import 'package:tpsl_printer/tpsl_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTpslPrinterPlatform 
    with MockPlatformInterfaceMixin
    implements TpslPrinterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TpslPrinterPlatform initialPlatform = TpslPrinterPlatform.instance;

  test('$MethodChannelTpslPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTpslPrinter>());
  });

  test('getPlatformVersion', () async {
    TpslPrinter tpslPrinterPlugin = TpslPrinter();
    MockTpslPrinterPlatform fakePlatform = MockTpslPrinterPlatform();
    TpslPrinterPlatform.instance = fakePlatform;
  
    // expect(await tpslPrinterPlugin.getPlatformVersion(), '42');
  });
}
