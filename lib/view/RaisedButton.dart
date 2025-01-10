


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? highlightColor;
  final double? elevation; 
  final double? highlightElevation;
  final double? disabledElevation;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Duration? animationDuration;
  final Widget? child;
  final Size? minimumSize;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final ButtonTextTheme? textTheme;


  const RaisedButton({super.key, this.onPressed, this.textColor,this.color,  this.highlightColor, this.elevation, this.highlightElevation, this.disabledElevation, this.padding, 
  this.shape, this.side, this.borderRadius, this.animationDuration, this.child, this.minimumSize, this.disabledColor, this.disabledTextColor, this.textTheme,
  });


  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  // onPrimary: Colors.black87,
  foregroundColor: textColor,
  elevation: elevation,
  side: side,
  // textStyle: textTheme,
  disabledBackgroundColor: disabledColor,
  disabledForegroundColor: disabledTextColor,
  // primary: Colors.grey[300],
  backgroundColor: color,
  minimumSize: minimumSize,
  animationDuration: animationDuration,
  padding: padding,
  shape: shape ?? RoundedRectangleBorder(
    borderRadius: borderRadius!=null?borderRadius!: const BorderRadius.all(Radius.circular(2)),
  ),
);
    return ElevatedButton(
      
      style: raisedButtonStyle,
      
      onPressed: onPressed,
      child: child,
    );
  }

}

