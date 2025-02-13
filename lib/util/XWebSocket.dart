import 'dart:async';
import 'dart:io';

import '../BaseConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef void OnData(dynamic message);
typedef void OnDone();
class XWebSocket<T> {
  late String connectUrl;
  WebSocketChannel? _websocketChannel;
  WebSocket? _webSocket;
  Function? onError;
  OnDone? onDone;
  OnData? onData;
  bool? cancelOnError;


  static Future<XWebSocket> connect(String url, {Iterable<String>? protocols}) async {
    XWebSocket socket = XWebSocket();
    socket.connectUrl = url;
    if(kIsWeb){
      socket._websocketChannel = WebSocketChannel.connect(Uri.parse(url));
    }else{
      socket._webSocket = await WebSocket.connect(url);
    }
    
    return socket;
  }

  Future<void> listen(OnData onData,
      {Function? onError, void onDone()?, bool? cancelOnError}) async {
        this.onError = onError;
        this.onDone = onDone;
        this.onData = onData;
        this.cancelOnError = cancelOnError;

    if (kIsWeb) {
      
      _websocketChannel?.stream.listen((data) {
        if (onData != null) {
          onData(data);
        }
      }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    }else{
        _webSocket?.listen((data) {
          if(onData != null){
            onData(data);
          }
        }, onError: onError,onDone: onDone, cancelOnError: cancelOnError);
    }
  }

  Future<void> reconnect() async {
    if(kIsWeb){
      if(_websocketChannel != null){
        _websocketChannel?.sink.close(status.goingAway);
        _websocketChannel = null;
        _websocketChannel = WebSocketChannel.connect(Uri.parse(connectUrl));
        _websocketChannel?.stream.listen((data) {
        if (onData != null) {
          onData!(data);
        }
      }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
      }
    }else{
      if(_webSocket != null){
        _webSocket?.close();
        _webSocket = null;
        try{
          _webSocket = await WebSocket.connect(connectUrl);
        }catch(ex){
          onError!(ex);
        }
        _webSocket?.listen((data) {
          if(onData != null){
            onData!(data);
          }
        }, onError: onError,onDone: onDone, cancelOnError: cancelOnError);
      }
    }
  }
  
  void add(/*String|List<int>*/ data){
    if(kIsWeb){
      WebSocketSink? sink = _websocketChannel?.sink;
      sink?.add(data);
    }else{
      _webSocket?.add(data);
    }
  }

  void close(){
    if(kIsWeb){
      _websocketChannel?.sink.close(status.goingAway);
    }else{
      _webSocket?.close();
    }
  }

  int? get readyState{
    if(kIsWeb){
      return _websocketChannel?.closeCode;
    }else{
      return _webSocket?.readyState;
    }
  }

}
