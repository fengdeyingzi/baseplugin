// import 'package:gbk2utf8/gbk2utf8.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../util/FileUtil.dart';
import '../util/XUtil.dart';
import '../BaseConfig.dart';
// import '../BaseConfig.dart';
/*
//post请求
var requestData = await XHttpUtils.request("http://url.com",
        method: XHttpUtils.POST,
        data: {"id":1},
        heads: {"lang":"zh"},
        contentType: XHttpUtils.formUrlEncodedContentType);
//Get请求
var requestData = await XHttpUtils.request("http://url.com",
        method: XHttpUtils.GET,
        data: {"id":1},
        heads: {"lang":"zh"},
        contentType: XHttpUtils.formUrlEncodedContentType);
*/
class XHttpUtils {
  //创建HttpClient
  final HttpClient _httpClient = HttpClient();
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String PATCH = 'PATCH';
  static const String DELETE = 'DELETE';
  static const int CONNECT_TIMEOUT = 3000; //连接时间
  static const int SEND_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000; //接收时间
  static const jsonContentType = 'application/json; charset=utf-8';
  static const formUrlEncodedContentType = 'application/x-www-form-urlencoded';


  //map转post form请求
  static String mapToPostData(Map<String, dynamic>? data) {
    print("data ${data}");
    StringBuffer buf_post = new StringBuffer();
    if (data != null) {
      data.forEach((key, value) {
        String urlValue = value.toString();
        if (value is String) {
          urlValue = Uri.encodeComponent(value);
        }

        buf_post.write("${key}=${urlValue}&");
      });
    }
    String re = buf_post.toString();
    if (re.isNotEmpty) {
      return re.substring(0, re.length - 1);
    }
    return re;
  }

  //创建http请求，method支持GET POST 返回map
  static Future<Map<String, dynamic>> request(String url,
      {Map<String, String>? heads,
      required Map<String, dynamic> data,
      String? method,
      String contentType = formUrlEncodedContentType}) async {
    Map<String, String> map_header = {};
    data.removeWhere((key, value) => value == null);
    int pos = 80;
    if (url.startsWith("https:")) {
      pos = 443;
    }
    Uri uri = Uri.parse(url);
    StringBuffer buffer = new StringBuffer();
    buffer.write("--> ${method} ${url} ");

    String postData = json.encode(data);
    map_header["content-type"] = contentType;
    if (heads != null) {
      map_header.addAll(heads);
    }
    if (contentType == formUrlEncodedContentType) {
      postData = mapToPostData(data);
      // print("键值对 ${postData}");
    }
    buffer.writeln("${postData}");
    print(map_header.toString());
    if (method == POST) {
      Uri uri = Uri.parse(url);
      try {
        http.Response response = await http
            .post(uri, headers: map_header, body: postData)
            .timeout(Duration(milliseconds: RECEIVE_TIMEOUT));
        buffer.write("${response.body}");
        try {
          // #ifdef PRINTHTTP
          if (BaseConfig.printHTTP) {
            print(buffer.toString());
          }



          // #endif
          return json.decode(response.body);
        } catch (e) {
          buffer.write("error : ${e}");
          // #ifdef PRINTHTTP
          if (BaseConfig.printHTTP) {
            print(buffer.toString());
          }



          // #endif

          return getInfoRequest(400, "${response.body}");
        }
      } catch (e) {
        buffer.write("error : ${e}");
        return getInfoRequest(404, "${e}");
      }
      // #ifdef PRINTHTTP
      if (BaseConfig.printHTTP) {
        print(buffer.toString());
      }



      // #endif
    } else if (method == GET) {
      if (postData.isNotEmpty) {
        url = url + "?" + postData;
      }
      Uri uri = Uri.parse(url);
      print("请求：" + url);
      try {
        http.Response response = await http.get(uri, headers: map_header);
        print("接收数据：${response.statusCode} ${response.body}");
        try {
          return json.decode(response.body);
        } catch (e) {
          print("error2 : ${e}");
          return getInfoRequest(400, "${response.body}");
        }
      } catch (e) {
        return getInfoRequest(404, "${e}");
        print("${e}");
      }
    }
    return getInfoRequest(404, "不支持的请求类型");
  }

//创建请求，返回字符串
  static Future<String?> requestBody(String url,
      {heads,
      Map<String, dynamic>? data,
      String? method,
      String coding = "UTF-8",String contentType = formUrlEncodedContentType}) async {
Map<String, String> map_header = {};
    
    int pos = 80;
    if (url.startsWith("https:")) {
      pos = 443;
    }
    Uri uri = Uri.parse(url);
    StringBuffer buffer = new StringBuffer();
    buffer.write("--> ${method} ${url} ");

    
    map_header["content-type"] = contentType;
    if (heads != null) {
      map_header.addAll(heads);
    }
    
    print(map_header.toString());
    if (method == POST) {
      data!.removeWhere((key, value) => value == null);
      String postData = json.encode(data);
      if (contentType == formUrlEncodedContentType) {
      postData = mapToPostData(data);
      // print("键值对 ${postData}");
      }
      buffer.writeln("${postData}");
      Uri uri = Uri.parse(url);
      try {
        http.Response response = await http
            .post(uri, headers: map_header, body: postData)
            .timeout(Duration(milliseconds: RECEIVE_TIMEOUT));
        buffer.write("${response.body}");
        try {
          return response.body;
        } catch (e) {
          buffer.write("error : ${e}");
          // #ifdef PRINTHTTP
          if (BaseConfig.printHTTP) {
            print(buffer.toString());
          }



          // #endif

          return null;
        }
      } catch (e) {
        buffer.write("error : ${e}");
        return null;
      }
      // #ifdef PRINTHTTP
      if (BaseConfig.printHTTP) {
        print(buffer.toString());
      }


      // #endif
    } else if (method == GET) {
      // if (postData.isNotEmpty) {
      //   url = url + "?" + postData;
      // }
      Uri uri = Uri.parse(url);
      print("请求：" + url);
      try {
        http.Response response = await http.get(uri, headers: map_header).timeout(Duration(milliseconds: RECEIVE_TIMEOUT));
        print("接收数据：${response.statusCode} ${response.body}");
        try {
          return response.body;
        } catch (e) {
          print("error2 : ${e}");
          return null;
        }
      } catch (e) {
        print("${e}");
        return null;

      }
    }
    return null;
  }

  //返回一个错误的数据
  static Map<String, dynamic> getInfoRequest2(int code, String msg) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = msg;
    data['time'] = "1000";
    data['Data'] = msg;
    data['StatusCode'] = code;
    return data;
  }

  static Map<String, dynamic> getInfoRequest(int code, String msg) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    data['time'] = "1000";
    data['data'] = msg;
    data['code'] = code;
    data['success'] = false;
    data['status'] = "1";
    return data;
  }

  

  ///其余的HEAD、PUT、DELETE请求用法类似，大同小异，大家可以自己试一下
  ///在Widget里请求成功数据后，使用setState来更新内容和状态即可
  ///setState(() {
  ///    ...
  ///  });

  static Future<List<int>> download(String url,
      {Map<String, String>? heads,
      Map<String, dynamic>? data,
      String contentType = formUrlEncodedContentType}) async {
    Map<String, String> map_header = {};

    int pos = 80;
    if (url.startsWith("https:")) {
      pos = 443;
    }

    StringBuffer buffer = new StringBuffer();
    buffer.write("--> download ${url} ");

    String postData = json.encode(data);
    map_header["content-type"] = contentType;
    if (heads != null) {
      map_header.addAll(heads);
    }
    if (contentType == formUrlEncodedContentType) {
      postData = mapToPostData(data);
      // print("键值对 ${postData}");
    }
    buffer.writeln("${postData}");
    print(map_header.toString());

    if (postData.isNotEmpty) {
      url = url + "?" + postData;
    }
    Uri uri = Uri.parse(url);
    print("请求：" + url);
    try {
      http.Response response = await http.get(uri, headers: map_header);
      print("接收数据：${response.statusCode} ${response.bodyBytes.length}");
      return response.bodyBytes;
    } catch (e) {
      return [];
    }
  }
}


/**
 * 请求响应数据
 */
class MsgResponse {
  int code; // 状态代码，0 表示没有错误
  Object? data; // 数据内容，一般为字符串
  String errmsg; // 错误消息
  MsgResponse([this.code = 0, this.data = null, this.errmsg = ""]);

  @override
  String toString() {
    return "code=${code} data=${data} errmsg=${errmsg}";
  }
}

 Map<String,String>? _makeHttpHeaders(
      [String? contentType,
      String? accept,
      String? token,
      String? XRequestWith,
      String? XMethodOverride]) {
    Map<String,String> headers = {};
    int i = 0;

    if (!XUtil.isEmpty(contentType)) {
      i++;
      headers["Content-Type"] = contentType!;
    }

    if (!XUtil.isEmpty(accept)) {
      i++;
      headers["Accept"] = accept!;
    }

    if (!XUtil.isEmpty(token)) {
      i++;
      headers["Authorization"] = "bearer " + token!;
    }

    if (!XUtil.isEmpty(XRequestWith)) {
      i++;
      headers["X-Requested-With"] = XRequestWith!;
    }

    if (!XUtil.isEmpty(XMethodOverride)) {
      i++;
      headers["X-HTTP-Method-Override"] = XMethodOverride!;
    }

    if (i == 0) return null;
    // print(headers.toString());
    return headers;
  }



/** HTTP POST 上传文件 */
   Future<MsgResponse> httpUploadFile(
    final String url,
    final File file, {
    String accept = "*/*",
    String? token,
    String field = "picture-upload",
    String? file_contentType, // 默认为null，自动获取
  }) async {
    try {
      List<int> bytes = await file.readAsBytes();
      return await httpUploadFileData(url, bytes,
          accept: accept,
          token: token,
          field: field,
          file_contentType: file_contentType,
          filename: file.path);
    } catch (e) {
      return new MsgResponse(699, null, e.toString());
    }
  }

  /** HTTP POST 上传文件 */
   Future<MsgResponse> httpUploadFileData(
    final String url,
    final List<int> filedata, {
    String accept = "*/*",
    String? token,
    String field = "filecontrol",
    String? file_contentType, // 默认为null，自动获取
    String? filename,
  }) async {
    try {
      List<int> bytes = filedata;
      var boundary = _boundaryString();
      String contentType = 'multipart/form-data; boundary=$boundary';
      Map<String,String>? headers =
          _makeHttpHeaders(contentType, accept, token); //, "XMLHttpRequest");

      // 构造文件字段数据
      String data =
          '--$boundary\r\nContent-Disposition: form-data; name="$field"; ' +
              'filename="${FileUtil.getName(filename!)}"\r\nContent-Type: ' +
              '${(file_contentType == null) ? getMediaType(FileUtil.getEndName(filename).toLowerCase()): file_contentType}\r\n\r\n';
      var controller = new StreamController<List<int>>(sync: true);
      controller.add(data.codeUnits);
      controller.add(bytes);
      controller.add("\r\n--$boundary--\r\n".codeUnits);

      controller.close();
      bytes = await new http.ByteStream(controller.stream).toBytes();
      //print("bytes: \r\n" + UTF8.decode(bytes, allowMalformed: true));

      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: bytes);
      if (response.statusCode == 200) { 
        return new MsgResponse(200, response.body);
      } else
        return new MsgResponse(response.statusCode, response.body);
    } catch (e) {
      return new MsgResponse(699, null, e.toString());
    }
  }

  /** 生成随机字符串 */
   String randomStr(
      [int len = 8, List<int> chars = _BOUNDARY_CHARACTERS]) {
    var list = new List<int>.generate(
        len, (index) => chars[_random.nextInt(chars.length)],
        growable: false);
    return new String.fromCharCodes(list);
  }

   const List<int> _BOUNDARY_CHARACTERS = const <int>[
    0x30,
    0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,
    0x37,
    0x38,
    0x39,
    0x61,
    0x62,
    0x63,
    0x64,
    0x65,
    0x66,
    0x67,
    0x68,
    0x69,
    0x6A,
    0x6B,
    0x6C,
    0x6D,
    0x6E,
    0x6F,
    0x70,
    0x71,
    0x72,
    0x73,
    0x74,
    0x75,
    0x76,
    0x77,
    0x78,
    0x79,
    0x7A,
    0x41,
    0x42,
    0x43,
    0x44,
    0x45,
    0x46,
    0x47,
    0x48,
    0x49,
    0x4A,
    0x4B,
    0x4C,
    0x4D,
    0x4E,
    0x4F,
    0x50,
    0x51,
    0x52,
    0x53,
    0x54,
    0x55,
    0x56,
    0x57,
    0x58,
    0x59,
    0x5A
  ];
   const int _BOUNDARY_LENGTH = 48;
   final Random _random = new Random();
   String _boundaryString() {
    var prefix = "---DartFormBoundary";
    var list = new List<int>.generate(
        _BOUNDARY_LENGTH - prefix.length,
        (index) =>
            _BOUNDARY_CHARACTERS[_random.nextInt(_BOUNDARY_CHARACTERS.length)],
        growable: false);
    return "$prefix${new String.fromCharCodes(list)}";
  }

   MediaType? getMediaType(final String fileExt) {
    switch (fileExt) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return  MediaType("image", "jpeg");
      case ".png":
        return  MediaType("image", "png");
      case ".bmp":
        return  MediaType("image", "bmp");
      case ".gif":
        return  MediaType("image", "gif");
      case ".json":
        return  MediaType("application", "json");
      case ".svg":
      case ".svgz":
        return  MediaType("image", "svg+xml");
      case ".mp3":
        return  MediaType("audio", "mpeg");
      case ".mp4":
        return  MediaType("video", "mp4");
      case ".htm":
      case ".html":
        return  MediaType("text", "html");
      case ".css":
        return  MediaType("text", "css");
      case ".csv":
        return  MediaType("text", "csv");
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return  MediaType("text", "plain");
    }
    return null;
  }

  class MediaType{
    String type;
    String format;
    MediaType(this.type,this.format);

    @override
  String toString() {
    return "${type}/${format}";
  }
  }
