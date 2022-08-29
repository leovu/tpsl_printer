/*
* Created by: bangnb
* Created at: 2022/08/23 14:16
*/
import 'dart:io';

class WifiCommunication{
  Socket? _client;
  String? _addressIp = null;
  int _port  = 9100;
  WifiHandler _handler;

  WifiCommunication(this._handler);

  Future<int> initSocket(String addressIp, int port) {
    this._addressIp = addressIp;
    this._port = port;
    if (this._client != null) {
       close();
    }
    return _connect(addressIp, port: port);
  }

  Future<int> _connect(String host,
      {int port = 91000, Duration timeout = const Duration(seconds: 30)}) async {
    try {
      _client = await Socket.connect(host, port, timeout: timeout);
      _handler.onConnected();
      return Future<int>.value(0);
    } catch (e) {
      print(e);
    }
    _handler.onConnectFailed();
    return Future<int>.value(1);
  }

  void close() {
    try {
      if (_client != null) {
        // _client!.flush();
        _client!.close();
        _client!.destroy();
      }
    } catch (e) {
      print(e);
    }
    _handler.onDisconnect();
    this._client = null;
  }

  void sendByte(List<int> bArr){
    _handler.onStartSendMessage();
    try {
      if(_client != null){
        _client!.add(bArr);
      }
    } catch (e) {
      print(e);
    }
    _handler.onEndSendMessage();
  }
}

class WifiHandler{
  Function onConnected;
  Function onConnectFailed;
  Function onStartSendMessage;
  Function onEndSendMessage;
  Function onDisconnect;
  WifiHandler({required this.onEndSendMessage, required this.onStartSendMessage, required this.onDisconnect, required this.onConnectFailed, required this.onConnected});
}