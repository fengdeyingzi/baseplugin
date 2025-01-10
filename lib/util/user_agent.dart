import 'html.dart' if (dart.library.html) 'dart:html' as html;
import 'dart:typed_data';

class UserAgent {
  @override
  String getUserAgent() {
    return html.window.navigator.userAgent;
  }

  Future<void> downloadFile(Uint8List data, String fileName) async {
    // 创建一个Blob对象
    final blob = html.Blob([data]);

    // 使用URL.createObjectURL()创建一个指向Blob的URL
    final url = html.Url.createObjectUrlFromBlob(blob);

    // 创建一个<a>元素用于下载文件
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click(); // 模拟点击下载

    // 释放URL
    html.Url.revokeObjectUrl(url);
  }
}
