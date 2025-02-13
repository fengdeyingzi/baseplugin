


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

class MouseEvent{
  void preventDefault() {}

}
class document{
  static Stream<MouseEvent> get onContextMenu => throw UnimplementedError();

}


class Blob {
  // To suppress missing implicit constructor warnings.
  factory Blob._() {
    throw new UnsupportedError("Not supported");
  }

  int get size{
    return 0;
  }

  String get type {
    return '';
  }

  Blob slice([int? start, int? end, String? contentType]){
    throw UnimplementedError();
  }

  factory Blob(List blobParts, [String? type, String? endings]) {
    // TODO: validate that blobParts is a JS Array and convert if not.
    // TODO: any coercions on the elements of blobParts, e.g. coerce a typed
    // array to ArrayBuffer if it is a total view.
    if (type == null && endings == null) {
      return _create_1(blobParts);
    }
    var bag = _create_bag();
    if (type != null) _bag_set(bag, 'type', type);
    if (endings != null) _bag_set(bag, 'endings', endings);
    return _create_2(blobParts, bag);
  }

  static _create_1(parts) => throw UnimplementedError();
  static _create_2(parts, bag) => throw UnimplementedError();

  static _create_bag() => throw UnimplementedError();
  static _bag_set(bag, key, value) {
    
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
