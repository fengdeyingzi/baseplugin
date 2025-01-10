
import 'package:flutter/material.dart';
import '../BaseConfig.dart';


class DateTimeUtil  {

  //获取日期
  // static String getDateTimeNumber1({DateTime? dateTime}){
  //   if(dateTime == null){
  //     dateTime= DateTime.now();
  //   }
    
  //   String year = _twoDigits(dateTime.year);
  //   String month = _twoDigits(dateTime.month);
  //   String day = _twoDigits(dateTime.day);
  //   String hour = _twoDigits(dateTime.hour);
  //   String minute = _twoDigits(dateTime.minute);
  //   String ss = _twoDigits(dateTime.second);
  //   return "${year}${month}${day}";
  // }

  static String getDateTimeNumber2({DateTime? dateTime}){
    if(dateTime==null){
      dateTime= DateTime.now();
    }
    
    String year = _twoDigits(dateTime.year);
    String month = _twoDigits(dateTime.month);
    String day = _twoDigits(dateTime.day);
    String hour = _twoDigits(dateTime.hour);
    String minute = _twoDigits(dateTime.minute);
    String ss = _twoDigits(dateTime.second);
    return "${year}-${month}-${day}";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  //获取格式化日期 根据语言不同而变化
  static String getDateTime1({DateTime? dateTime}){
    if(dateTime == null){
      dateTime = DateTime.now();
    } 
    
    String year = _twoDigits(dateTime.year);
    String month = _twoDigits(dateTime.month);
    String day = _twoDigits(dateTime.day);
    String hour = _twoDigits(dateTime.hour);
    String minute = _twoDigits(dateTime.minute);
    String ss = _twoDigits(dateTime.second);
    return "${year}年${month}月${day}日";
  }

  // static String getDateTime2({DateTime? dateTime}){
  //   if(dateTime == null){
  //     dateTime= DateTime.now();
  //   }
    
  //   int year = (dateTime.year);
  //   int month = (dateTime.month);
  //   int day = (dateTime.day);
  //   int hour = (dateTime.hour);
  //   int minute = (dateTime.minute);
  //   int ss = (dateTime.second);
  //   return "${year}年${month}月${day}日";
  // }


   
}


