


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

  int get size native;

  String get type native;

  Blob slice([int? start, int? end, String? contentType]) native;

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

  static _create_1(parts) => JS('Blob', 'new self.Blob(#)', parts);
  static _create_2(parts, bag) => JS('Blob', 'new self.Blob(#, #)', parts, bag);

  static _create_bag() => JS('var', '{}');
  static _bag_set(bag, key, value) {
    JS('void', '#[#] = #', bag, key, value);
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
