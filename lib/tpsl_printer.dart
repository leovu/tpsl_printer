import 'dart:typed_data';

import 'package:tpsl_printer/printer/PrinterUtil.dart';
import 'package:tpsl_printer/printer/wifi_communication.dart';

class TpslPrinter {
  static connect(WifiCommunication wifiCommunication, String ip, {int port = 9100}) async {
    await wifiCommunication.initSocket(ip, port);
  }
  static Future<bool> send(WifiCommunication wifiCommunication, Uint8List data,{int printTime = 1,int width = 380, height = 275}) async {
    bool result = true;
    try{
      PrinterUtil printer = PrinterUtil();
      printer.printWifiTspl(printTime, width, height, data, wifiCommunication, "init", "");
    } catch (e) {
      print(e);
      result = false;
    }
    return result;
  }
  static close(WifiCommunication wifiCommunication) {
    wifiCommunication.close();
  }
}
