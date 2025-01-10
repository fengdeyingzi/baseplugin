import 'dart:async';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/XDialog.dart';
import '../util/XUtil.dart';
import '../view/XCard.dart';
import '../BaseConfig.dart';
import 'package:flutter/foundation.dart';


/*
550 行 添加路由
 */
abstract class BaseWidget extends StatefulWidget {

  const BaseWidget({Key? key}) : super(key: key);


}

abstract class BaseState<T extends BaseWidget> extends State<T>
    with WidgetsBindingObserver {
  static const MethodChannel _methodChannel = MethodChannel('FlutterActivity');

//  T get widget => _widget;
//  T _widget;
  bool isDispose = false;
  bool _isShowLoading = false;
  String? _loadingText = "加载中";

  BuildContext? loading_context;

  //定义app状态
  int STATE_LOADING = 1; //加载中
  int STATE_ERROR = -1; //加载失败
  int STATE_NONE = 0; //空数据
  int STATE_START = 4; //初始界面
  int STATE_SUCCESS = 3; //加载完成

//  SpecificLocalizationDelegate _localeOverrideDelegate;
  bool isShowShare = false;
  bool isShowWidget = true; //显示当前widget
  Locale locale_zh = const Locale('zh', '');
  Locale locale_en = const Locale('en', '');
  bool isGotoLogin = false;
  Color _backgroundColor = Color(0xffFEFEFE);
  static const eventPlugin_news = EventChannel("eventNews");
  StreamSubscription? _streamSubscription;
  final SystemUiOverlayStyle _style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light);

//  BuildContext _contextBaseFunction;
  static const fromAndroidPlugin =
  EventChannel("com/ocketautoparts.qimopei/plugin");

  // 响应空白处的焦点的Node
  final FocusNode _blankNode = FocusNode();


  //



  double getTop() {
    return window.padding.top / window.devicePixelRatio;
//   return MediaQuery.of(context).padding.top;
  }


  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    this.isDispose = false;
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }


  void setBackgroundColor(Color color) {
    update(() {
      _backgroundColor = color;
    });
  }


  bool isDebug() {
//    return false;
    // if (BaseConfig.platform == "web") return false;
    // if (BaseConfig.platform == "windows") return true;
    // if (BaseConfig.platform == "android") return false;
    bool inProduction = const bool.fromEnvironment("dart.vm.product");
    return kDebugMode;
  }

  void setShowWidget(bool isShow) {
    this.isShowWidget = isShow;
  }

  //调试用的toast
  void showLogToast(String text) {
    if (isDebug()) {
      toast("log:${text}");
    }
    print("log:${text}");
  }

  @override
  void dispose() {
    super.dispose();
    this.isDispose = true;
  }


  //显示loading
  void showLoading({String? text}) {
    setState(() {
      _loadingText = text;
      _isShowLoading = true;
    });
  }



  //设置state
  void update(VoidCallback fn) {
    if (!isDispose){
      setState((){
        fn();
      });
    }

  }

  //取消显示loading
  void hideLoading() {
    print("关闭loading");
    setState(() {
      _isShowLoading = false;
    });
  }

  //获取加载中loading
  Widget getLoading({String? text}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 4.0,
            backgroundColor: Colors.transparent,
            // value: 0.2,
            valueColor:
            new AlwaysStoppedAnimation<Color>(BaseConfig.colorAccent),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            text ?? "加载中",
            style: TextStyle(
                fontSize: BaseConfig.font_h3,
                color: BaseConfig.textColor,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }


  //获取加载失败
  Widget getErrorLoad(GestureTapCallback onTap, {bool? showImg}) {
    if (showImg == null) showImg = true;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
//      height: double.infinity,
      child: InkResponse(
        onTap: onTap,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showImg
                  ? Image.asset(
                "assets/state_none.png",
                width: 187,
                height: 187,
//                      color: BaseConfig.light_gray,
              )
                  : SizedBox(),
              SizedBox(
                height: 8,
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: const [
                  Text(
                    "网络已断开",
                    style: TextStyle(
                        fontSize: BaseConfig.font_h3,
                        color: BaseConfig.colorControlNormal),
                  ),
                  SizedBox(
                    height: 50,
                    width: 8,
                  ),
                  Text(
                    "请连接网络后，点击刷新",
                    style: TextStyle(
                      fontSize: BaseConfig.font_h3,
                      color: BaseConfig.colorAccent,
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  //获取空白界面
  Widget getEmptyLoad({bool? showImg,String? text}) {
    if (showImg == null) {
    showImg = true;
    }
    return showImg ? Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "assets/state_none.png",
            width: 120,
            height: 120,
//            color: BaseConfig.light_gray,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            text??"里面什么都没有~",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: BaseConfig.font_h3,
                color: BaseConfig.gray),
          ),
        ],
      ),
    ) : Container(
      height: 60,
      alignment: Alignment.center,
      child: Text("暂无内容", style: TextStyle(
          fontSize: BaseConfig.font_h3,
          color: BaseConfig.gray
      ),),
    );
  }

  //简单实现路由跳转
  Future<K?> navigationTo<K extends Object>(Widget widget) {
    return Navigator.push<K>(context, new MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  //跳转界面并清除以前的界面（全部？）
  void navigationToAndPop(Widget widget) {
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(builder: (context) {
          return widget;
        }), (route) => true);
  }

  //跳转并销毁当前
  void navigationToAndRep(Widget widget) {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) {
          return widget;
        }));
  }

  void navigationPop<K extends dynamic>({K? result}) {
//    Navigator.pop 可以有一个参数或两个参数，如果只有一个参数，为上下文环境；如果两个参数，第二个参数为返回值内容，可以为多种类型。
    Navigator.pop(context, result);
  }

  //通过路由名称跳转并传递参数
  Future<K> navigationNameTo<K extends dynamic>(String name,
      {Object? arguments, bool isReplacement = false,bool isPopAll=false}) async {
    hideKeyBoard();
    if(isPopAll){
      return await Navigator.pushNamedAndRemoveUntil(context, name,(route) => false, arguments: arguments).then((value) {
        onResume();
      } as FutureOr<K> Function(dynamic));
    }
    else if (isReplacement) {
      return await Navigator.pushReplacementNamed(context, name,
          arguments: arguments).then((value) {
        onResume();
      } as FutureOr<K> Function(dynamic));
    } else {
      return await Navigator.pushNamed<K>(context, name, arguments: arguments)
          .then((value) {
        onResume();
      } as FutureOr<K> Function(K?));
    }
  }






  //显示toast
  Future toast(String msg) async {
    if(msg.length>512){
      BotToast.showText(text: msg.substring(0,512),duration: Duration(seconds: 3)); //popup a text toast;
    }else{
      BotToast.showText(text: msg); //popup a text toast;
    }
    
  }

  Future<T?> showInfoDialog(String info,
      {String? title, VoidCallback? confirmCallback,
        VoidCallback? cancelCallback,
        String? confirmText,
        String? cancelText}) {
return    showCupertinoDialog(context: context,
    barrierDismissible: true,
    builder:(BuildContext ctx){
      if(info.length < 50){
return XDialog.buildWeChatDialog(
          context, title??"提示", info, confirmText: confirmText,
          cancelText: cancelText,
          confirmCallback: confirmCallback,
          cancelCallback: cancelCallback);
      }else{
        return XDialog.buildWeChatDialog(
          context, title??"提示", info, confirmText: confirmText,
          cancelText: cancelText,
          confirmCallback: confirmCallback,
          cancelCallback: cancelCallback,child: Container(width: double.infinity,height: 240,child: SingleChildScrollView(
        child: Text(info),
      ),));
      }
      
    });

  }

  //显示一个输入框 并监听输入文字
  void showInputDialog({String? title,
    required String text,
    ValueChanged? confirmCallback,
    VoidCallback? cancelCallback}) {
    TextEditingController controller = new TextEditingController();
    controller.text = text;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 260,
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
//      color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ConstrainedBox(
                            child: SingleChildScrollView(
                              child: TextField(
                                controller: controller,
                              ),
                            ),
                            constraints: BoxConstraints(
//                    minWidth: double.infinity, //宽度尽可能大
                                maxHeight: 320 //最小高度为50像素
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if(confirmCallback!=null) {
                                    confirmCallback(controller.text);
                                  }
                                },
                                child: Text(
                                  "确定",
                                  style: TextStyle(
                                      color: Color(0xFF1363DB),
                                      fontSize: BaseConfig.font_h3),
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if(cancelCallback!=null) {
                                    cancelCallback();
                                  }
                                },
                                child: Text("取消", style: TextStyle(
                                    color: Color(0xFF1363DB),
                                    fontSize: BaseConfig.font_h3))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }




  //获取当前类名
  String getClassName() {
//    if (_contextBaseFunction == null) {
//      return null;
//    }
    String className = context.toString();
    
    if (!className.contains("(")) return className;
    className = className.substring(0, className.indexOf("("));
    return className;
  }

  //退出app
  void exit() {
    SystemNavigator.pop();
  }

  //关闭键盘
  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(_blankNode);
  }

  @override
  Widget build(BuildContext context) {
    // double bottom_size = MediaQuery.of(context).systemGestureInsets.bottom;
    return Material(
        type: MaterialType.transparency,
        color: BaseConfig.light_gray,
        child: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            FocusScope.of(context).requestFocus(_blankNode);
          },
          child: Container(
            color: BaseConfig.editLineColor,
            child: SafeArea(
              bottom: true,
              top: false,
              child: Container(
                color: _backgroundColor,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Container(
                          width: double.infinity,
                          height: double.infinity,
                          child:
                          DefaultTextStyle(
                              style: const TextStyle(
                                  color: BaseConfig.textColor,
                                  fontSize: BaseConfig.font_h3
                              ),
                              child: buildWidget(context)),

                        ),
                    _isShowLoading
                        ? MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(splashColor: Colors.transparent),
                      home: Ink(
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                                width: 160,
                                child: XCard(
                                    child: SizedBox(
                                        height: 120,
                                        child: getLoading(
                                            text:
                                            _loadingText ?? "加载中")))),
                          ),
                        ),
                      ),
                    )
                        : const SizedBox(),
                    isDebug() && isShowWidget
                        ? GestureDetector(
                      onTap: () {
                        StringBuffer buffer = StringBuffer();
                        List<String> data = getHttpData();
                        for (String item in data) {
                          buffer.write(item);
                          buffer.write("\n\n");
                        }
//                      XUtil.copyToClipboard(HttpUtils.lastBuffer);
                        XUtil.copyToClipboard(buffer.toString());
                        toast("已复制联网数据");
                      },
                      onDoubleTap: () {
                        // navigationTo(DebugWidget());
                      },
                      onLongPress: () {
                        // XUtil.copyToClipboard("" + BaseConfig.FInterID);
                        toast("FInterID已复制");
                        setState(() {
                          isShowWidget = false;
                        });

                      },
                      child: Container(
//                    alignment: Alignment.center,
                        height: 24,
                        color: const Color(0x80000000),
                        padding: const EdgeInsets.fromLTRB(8, 0, 32, 0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Align(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Text(
                            getClassName(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: BaseConfig.font_h5),
                          ),
                        ),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),

              ),
            ),
          ),
        ));
  }

  Widget buildWidget(BuildContext context);

  List<String> getHttpData();

  @override
  void reassemble() {
    super.reassemble();
    if (ModalRoute
        .of(context)!
        .isCurrent) {
      onReStart();
    }
  }

  //热加载
  @protected
  @mustCallSuper
  void onReStart() {

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
//        GetShareHelper.getShare();
        if (ModalRoute
            .of(context)!
            .isCurrent) onResume();
        break;
      case AppLifecycleState.paused:
        if (ModalRoute
            .of(context)!
            .isCurrent) onPause();
        break;
      case AppLifecycleState.inactive:
      if (ModalRoute
            .of(context)!
            .isCurrent) inActive();
        break;
      default:
        break;
    }
  }



  @protected
  @mustCallSuper
  void onPause() {}

  @protected
  @mustCallSuper
  void onResume() {
  }

  @protected
  @mustCallSuper
  void inActive() {
  }
}

typedef OnParseSuccess = void Function(Map<String,dynamic> json);
typedef OnParseError = void Function(String msg);
typedef OnChangeLanguage = void Function(String language);


//定义语言切换的事件监听类
class ChangeLanguageEvent {
  String language;

  ChangeLanguageEvent(this.language);
}
