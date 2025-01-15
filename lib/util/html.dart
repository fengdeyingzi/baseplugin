


import 'dart:io';

import 'package:baseplugin/util/user_agent.dart';

class Navigator{
  static String _userAgent = ''+Platform.operatingSystem;

  String get userAgent{
    return _userAgent;
  }
}


class window{
  static Navigator navigator = Navigator();
}


class Blob {
  // To suppress missing implicit constructor warnings.
  factory Blob._() {
    throw new UnsupportedError("Not supported");
  }

  int size = 0;

  String type = "";

  Blob slice([int? start, int? end, String? contentType]) native;

  Blob(List blobParts, [String? type, String? endings]) {
    
  }
  
}


class AnchorElement{
  // To suppress missing implicit constructor warnings.
  factory AnchorElement._() {
    throw new UnsupportedError("Not supported");
  }

  factory AnchorElement({String? href}) {
    return AnchorElement();
  }

  AnchorElement.created();





  setAttribute(String s, String fileName) {}

  click() {}
}


class Url  {
  static createObjectUrlFromBlob(Blob blob) {}

  static void revokeObjectUrl(url) {}

}
