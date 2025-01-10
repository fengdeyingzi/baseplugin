

import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget{
  final VoidCallback? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? highlightedBorderColor;
  final Color? textColor;
  final Color? color;
  final BorderSide? side;
  final BorderSide? borderSide;
  final ButtonTextTheme? textTheme;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final double? highlightElevation;
  final  OutlinedBorder? shape;
 
  const OutlineButton({super.key, this.onPressed, this.side, this.borderSide, this.padding, this.color, this.splashColor, this.highlightColor, this.highlightedBorderColor, this.textColor, this.child, this.textTheme, this.materialTapTargetSize, this.elevation, this.highlightElevation, this.shape});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  // onPrimary: Colors.black87,
  foregroundColor: textColor,
  // backgroundColor: color,
  tapTargetSize:materialTapTargetSize,
  // elevation: elevation,
  // side: side,
  elevation: elevation,
  // primary: Colors.grey[300],
  // backgroundColor: color,
  // minimumSize: minimumSize,
  // animationDuration: animationDuration,
  
  padding: padding,
  side: side??borderSide,
  shape: shape??  RoundedRectangleBorder(
    
    borderRadius: BorderRadius.all(Radius.circular(2)),
    side: side??BorderSide(color: color??Colors.black)
  ),
);
    return OutlinedButton(
      style: outlineButtonStyle,
      onPressed: onPressed,
      
      // padding: padding,
      // splashColor: splashColor,
      // highlightColor: highlightColor,
      // highlightedBorderColor: highlightedBorderColor,
      // textColor: textColor,
      child: child??Text(""),
    );
  }
  


}