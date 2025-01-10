

import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget{
  final Widget? child;
final VoidCallback? onPressed;
final Color? textColor;
final VoidCallback? onLongPress;
final Color? backgroundColor;
final MaterialTapTargetSize? materialTapTargetSize;

  const FlatButton({super.key, this.onPressed, this.onLongPress,this.child,this.textColor,this.backgroundColor, this.materialTapTargetSize});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: textColor,
      tapTargetSize:materialTapTargetSize,
      backgroundColor: backgroundColor,
    );
    return TextButton(
      onLongPress:onLongPress,
      style: style,
      onPressed: onPressed,
      child: child??const Text(""),
    );
  }

}