// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.
library baseplugin;

export 'view/FlatButton.dart';
export 'view/OutlineButton.dart';
export 'view/RaisedButton.dart';
export 'view/WhitelistingTextInputFormatter.dart';
export 'util/MyCustomScrollBehavior.dart';
export 'base/BaseWidget.dart';
export 'util/ColorUtil.dart';
export 'util/DateTimeUtil.dart';
export 'util/FileUtil.dart';
export 'util/XDialog.dart';
export 'util/XHttpUtils.dart';
export 'util/XUtil.dart';
export 'util/user_agent.dart';
import 'baseplugin_platform_interface.dart';
export "util/XWebSocket.dart";



class Baseplugin {
  Future<String?> getPlatformVersion() {
    return BasepluginPlatform.instance.getPlatformVersion();
  }

  
}
