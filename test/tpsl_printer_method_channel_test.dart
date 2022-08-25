import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tpsl_printer/tpsl_printer_method_channel.dart';

void main() {
  MethodChannelTpslPrinter platform = MethodChannelTpslPrinter();
  const MethodChannel channel = MethodChannel('tpsl_printer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
