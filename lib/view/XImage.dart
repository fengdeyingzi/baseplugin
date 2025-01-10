import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import "../BaseConfig.dart";
import 'package:flutter/material.dart';

/*
构建一个可以设置占位图以及错误图片的控件
如果不设置 默认为灰色背景框
 */
class XImage extends StatelessWidget {
 final String? noneImage;
 final String? errorImage;
 final String? imageUrl;
 final double? width;
 final double? height;
 final BoxFit? fit;
 final double? radius;
 final Color? color;
 /// Will resize the image in memory to have a certain width using [ResizeImage]
 final int? memCacheWidth;

 /// Will resize the image in memory to have a certain height using [ResizeImage]
 final int? memCacheHeight;

 const XImage(this.imageUrl,{Key? key, this.fit,this.errorImage,this. noneImage,this.width,this.height, this.memCacheWidth, this.memCacheHeight,this.radius=0,this.color}) : super(key: key);

  Widget buildWebImage(){
    if(imageUrl==null || imageUrl!.isEmpty){
      return Image.asset(errorImage??"assets/photo_error.png",width: width,height: height,fit:  fit??BoxFit.cover,);
    }
    if(imageUrl!.startsWith("http://") || imageUrl!.startsWith("https://")){
//      return CachedNetworkImage(
//        placeholder: (BuildContext context,String img){
//          return Image.asset(noneImage??"assets/photo.png",fit: fit??BoxFit.cover,width: width,height: height,);
//        },
//        errorWidget: (BuildContext,String img,Object error){
//          return Image.asset(errorImage??"assets/photo_error.png",width: width,height: height,fit: fit??BoxFit.cover,);
//        },
//        imageUrl: imageUrl,
//        width: width,
//        height: height,
//        fit: fit??BoxFit.cover,
//      );
      return FadeInImage.assetNetwork(
        placeholder: noneImage??"assets/photo.png",
        imageErrorBuilder: getErrorBuilder(),
        image: imageUrl!,
        width: width,
        height: height,
        fit: fit??BoxFit.cover,
      );
    }
    else if(imageUrl!.startsWith("data:")){ //base64
      print("加载base64图片：${imageUrl}");
      return Image.memory(base64Decode(imageUrl!.split(',')[1]),width: width,height: height,fit:  fit??BoxFit.cover,);
    } else {
      if(BaseConfig.platform == "web"){
        return Image.asset(imageUrl!,width: width,height: height,fit:  fit??BoxFit.cover,errorBuilder: getErrorBuilder(),);
      }
      File file = new File(imageUrl!);
      if(file.existsSync()){
        print("image file"+imageUrl!);
        return Image.file(file,width: width,height: height,fit:  fit??BoxFit.cover,errorBuilder: getErrorBuilder(),);
      }
      else{
        print("image asset"+imageUrl!);
        return Image.asset(imageUrl!,width: width,height: height,fit:  fit??BoxFit.cover,errorBuilder: getErrorBuilder());
      }

    }
  }

  ImageErrorWidgetBuilder getErrorBuilder(){
    return  (BuildContext context, Object error, StackTrace? stackTrace,){
    return Container(width: width,height: height,color: Color(0x20808080),child: SizedBox(),);
  };
  }

  Widget buildImage(){
    if(imageUrl==null || imageUrl!.isEmpty){
      return Image.asset(errorImage??"assets/photo_error.png",width: width,height: height,fit:  fit??BoxFit.cover,);
    }
    if(imageUrl!.startsWith("http://") || imageUrl!.startsWith("https://")) {
      return CachedNetworkImage(
        placeholder: (BuildContext context,String img){
          return Image.asset(noneImage??"assets/photo.png",fit: fit??BoxFit.cover,width: width,height: height,);
        },
        errorWidget: (cx,String img,Object? error){
          return Image.asset(errorImage??"assets/photo_error.png",width: width,height: height,fit: fit??BoxFit.cover,);
        },
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit??BoxFit.cover,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
      );
    } else if(imageUrl!.startsWith("data:")){ //base64
     print("加载base64图片：");
      return Image.memory(base64Decode(imageUrl!.split(',')[1]),width: width,height: height,fit:  fit??BoxFit.cover,);
    } else{
      File file = new File(imageUrl!);
      if(file.existsSync()){
        print("image file"+imageUrl!);
        return Image.file(file,width: width,height: height,fit:  fit??BoxFit.cover,errorBuilder: getErrorBuilder(),);
      }
      else{
        print("image asset"+imageUrl!);
        return Image.asset(imageUrl!,width: width,height: height,fit:  fit??BoxFit.cover,errorBuilder: getErrorBuilder(),);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!),
      child: Semantics(
        image: true,
        child: Container(
          color: color,
          child: (BaseConfig.platform=="web"||BaseConfig.platform=="windows")?buildWebImage(): buildImage()),
      ),
    );

  }

  //获取商家列表的logo图
  static Widget getListLogo(String url){
    return XImage(
      url ,
      width: 88,
      radius: 4,
      height: 62,
      fit: BoxFit.cover,
    );
  }

  static Widget getCompanyLogo(String url){
    return XImage(
      url ,
      radius: 4,
      width: 88,
      height: 62,
      fit: BoxFit.fill,
      noneImage: "assets/mrpic.png",
      errorImage: "assets/mrpic.png",
    );
  }

}

