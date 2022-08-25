import 'dart:typed_data';

import 'package:tpsl_printer/printer/PrinterUtil.dart';
import 'package:tpsl_printer/printer/wifi_communication.dart';

class TpslPrinter {
  static WifiCommunication? wifiCommunication;
  static connect(String ip, {int port = 9100}) async {
    TpslPrinter.wifiCommunication = WifiCommunication(
        WifiHandler(
            onConnected: (){
              print("onConnected");
            },
            onConnectFailed: (){
              print("onConnectFailed");
            },
            onDisconnect: (){
              print("onDisconnect");
            },
            onEndSendMessage: (){
              print("onEndSendMessage");
            },
            onStartSendMessage: (){
              print("onStartSendMessage");
            }
        )
    );
    int result = await TpslPrinter.wifiCommunication!.initSocket(ip, port);
    return result == 0 ? true : false;
  }
  static Future<bool> send(Uint8List data,{int printTime = 1,int width = 380, height = 275}) async {
    bool result = true;
    try{
      PrinterUtil printer = PrinterUtil();
      printer.printWifiTspl(printTime, width, height, data, TpslPrinter.wifiCommunication, "init", "");
    } catch (e) {
      print(e);
      result = false;
    }
    return result;
  }
  static close() {
    TpslPrinter.wifiCommunication?.close();
  }
}
