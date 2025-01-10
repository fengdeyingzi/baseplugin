
/*
颜色处理

*/

 import 'dart:ui';

import 'package:sprintf/sprintf.dart';

class ColorUtil {

    //将rgb565转rgb格式
     static int rgb565ToColor(int rgb565) {
        int r = rgb565 >> 16 << 3;
        int g = rgb565 >> 8 << 2;
        int b = rgb565 << 3 & 0xff;
        return (r << 16) | (g << 8) | b;
    }

    //将rgb转rgb565格式
    static int makeColor565(int r, int g, int b) {
        return ((r << 8) & 0x1f | (g << 3) & 0x3f | b >> 3);
    }

    //获取颜色灰度值
    static int getBlack(int color) {
        int r = getR(color);
        int g = getG(color);
        int b = getB(color);
        return (r + g + b) ~/ 3;
    }

    //在颜色中混合一层颜色(带透明度信息)
    static int mixColor(int color1, int color2) {
        int a1 = color1 >> 24 & 0xff;
        int r1 = color1 >> 16 & 0xff;
        int g1 = color1 >> 8 & 0xff;
        int b1 = color1 & 0xff;

        // int a2 = color2 >> 24 & 0xff;
        int r2 = color2 >> 16 & 0xff;
        int g2 = color2 >> 8 & 0xff;
        int b2 = color2 & 0xff;

        int draw_a = color2 >> 24;
        // int a = a1 * (255 - draw_a) ~/ 255 + a2 * draw_a ~/ 255;
        int r = r1 * (255 - draw_a) ~/ 255 + r2 * draw_a ~/ 255;
        int g = g1 * (255 - draw_a) ~/ 255 + g2 * draw_a ~/ 255;
        int b = b1 * (255 - draw_a) ~/ 255 + b2 * draw_a ~/ 255;
        return (a1 << 24) | (r << 16) | (g << 8) | b;
    }

    //将两个颜色混合(比例1:1)
    static int mergerColor(int color1, int color2) {
        int a1 = color1 >> 24 & 0xff;
        int r1 = color1 >> 16 & 0xff;
        int g1 = color1 >> 8 & 0xff;
        int b1 = color1 & 0xff;

        int a2 = color2 >> 24 & 0xff;
        int r2 = color2 >> 16 & 0xff;
        int g2 = color2 >> 8 & 0xff;
        int b2 = color2 & 0xff;

        int draw_a = 128;
        int a = a1 * (255 - draw_a) ~/ 255 + a2 * draw_a ~/ 255;
        int r = r1 * (255 - draw_a) ~/ 255 + r2 * draw_a ~/ 255;
        int g = g1 * (255 - draw_a) ~/ 255 + g2 * draw_a ~/ 255;
        int b = b1 * (255 - draw_a) ~/ 255 + b2 * draw_a ~/ 255;
        return (a << 24) | (r << 16) | (g << 8) | b;
    }
    //改变颜色亮度 参数：原始颜色，亮度值(0~255)

    //将颜色变亮 参数：原始颜色，亮度增量(0～100)
    static int lightColor(int color, int size) {
        int a1 = color >> 24 & 0xff;
        int r1 = color >> 16 & 0xff;
        int g1 = color >> 8 & 0xff;
        int b1 = color & 0xff;

        int a = a1 + (255 - a1) * size ~/ 100;
        int r = r1 + (255 - r1) * size ~/ 100;
        int g = g1 + (255 - g1) * size ~/ 100;
        int b = b1 + (255 - b1) * size ~/ 100;
        return (a << 24) | (r << 16) | (g << 8) | b;
    }

    static Color lightColor2(Color c, int size) {
      int color = c.value;
        int a1 = color >> 24 & 0xff;
        int r1 = color >> 16 & 0xff;
        int g1 = color >> 8 & 0xff;
        int b1 = color & 0xff;

        int a = a1 + (255 - a1) * size ~/ 100;
        int r = r1 + (255 - r1) * size ~/ 100;
        int g = g1 + (255 - g1) * size ~/ 100;
        int b = b1 + (255 - b1) * size ~/ 100;
        return Color((a << 24) | (r << 16) | (g << 8) | b);
    }

    //将颜色变暗 参数：原始颜色，亮度(0-100)
    static int blackColor(int color, int size) {
        int a1 = color >> 24 & 0xff;
        int r1 = color >> 16 & 0xff;
        int g1 = color >> 8 & 0xff;
        int b1 = color & 0xff;

        int a = a1 * size ~/ 100;
        int r = r1 * size ~/ 100;
        int g = g1 * size ~/ 100;
        int b = b1 * size ~/ 100;
        return (a << 24) | (r << 16) | (g << 8) | b;

    }

    //将颜色值#ffffffff转int
    //读取颜色值
    static int getColor(String text) {
        int color = 0;
        List<int> argb = [0,0,0,0];
        int start = 0;
        int i = 0;
        int hex = 0; //颜色位数 有3 4 6 8
        for (i = 0; i < text.length; i++) {
            if (text[i] == '#') {
                start = i + 1;
                hex = text.length - start;
            }

        }
        if (hex == 3) {
            for (i = 0; i < 3; i++) {
                var c = text[start + i].codeUnitAt(0);
                argb[0] = 0xff;
                if (c >= 'A'.codeUnitAt(0) && c <= 'F'.codeUnitAt(0)) {
                    argb[i + 1] = (c - 'A'.codeUnitAt(0) + 10) * 16;
                } else if (c >= 'a'.codeUnitAt(0) && c <= 'f'.codeUnitAt(0)) {
                    argb[i + 1] = (c - 'a'.codeUnitAt(0) + 10) * 16;
                } else if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
                    argb[i + 1] = (c - '0'.codeUnitAt(0)) * 16;
                }
            }
        } else if (hex == 6) {
            argb[0] = 0xff;
            for (i = 0; i < 3; i++) {
                var c = text[start + i * 2].codeUnitAt(0);
                var c2 = text[start + i * 2 + 1].codeUnitAt(0);

                if (c >= 'A'.codeUnitAt(0) && c <= 'F'.codeUnitAt(0)) {
                    argb[i + 1] = (c - 'A'.codeUnitAt(0) + 10) << 4;
                } else if (c >= 'a'.codeUnitAt(0) && c <= 'f'.codeUnitAt(0)) {
                    argb[i + 1] = (c - 'a'.codeUnitAt(0) + 10) << 4;
                } else if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
                    argb[i + 1] = (c - '0'.codeUnitAt(0)) << 4;
                }
                if (c2 >= 'A'.codeUnitAt(0) && c2 <= 'F'.codeUnitAt(0)) {
                    argb[i + 1] |= (c2 - 'A'.codeUnitAt(0) + 10);
                } else if (c2 >= 'a'.codeUnitAt(0) && c2 <= 'f'.codeUnitAt(0)) {
                    argb[i + 1] |= (c2 - 'a'.codeUnitAt(0) + 10);
                } else if (c2 >= '0'.codeUnitAt(0) && c2 <= '9'.codeUnitAt(0)) {
                    argb[i + 1] |= (c2 - '0'.codeUnitAt(0));
                }
            }
        } else if (hex == 4) {
            for (i = 0; i < 4; i++) {
                var c = text[start + i].codeUnitAt(0);
                if (c >= 'A'.codeUnitAt(0) && c <= 'Z'.codeUnitAt(0)) {
                    argb[i] = ((c - 'A'.codeUnitAt(0)) + 10) * 16;
                } else if (c >= 'a'.codeUnitAt(0) && c <= 'z'.codeUnitAt(0)) {
                    argb[i] = (c - 'a'.codeUnitAt(0) + 10) * 16;
                } else if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
                    argb[i] = (c - '0'.codeUnitAt(0)) * 16;
                }
            }
        } else if (hex == 8) {
            for (i = 0; i < 4; i++) {
                var c = text[start + i * 2].codeUnitAt(0);
                var c2 = text[start + i * 2 + 1].codeUnitAt(0);
                if (c >= 'A'.codeUnitAt(0) && c <= 'F'.codeUnitAt(0)) {
                    argb[i] = (c - 'A'.codeUnitAt(0) + 10) << 4;
                } else if (c >= 'a'.codeUnitAt(0) && c <= 'f'.codeUnitAt(0)) {
                    argb[i] = (c - 'a'.codeUnitAt(0) + 10) << 4;
                } else if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
                    argb[i] = (c - '0'.codeUnitAt(0)) << 4;
                }
                if (c2 >= 'A'.codeUnitAt(0) && c2 <= 'F'.codeUnitAt(0)) {
                    argb[i] |= (c2 - 'A'.codeUnitAt(0) + 10);
                } else if (c2 >= 'a'.codeUnitAt(0) && c2 <= 'f'.codeUnitAt(0)) {
                    argb[i] |= (c2 - 'a'.codeUnitAt(0) + 10);
                } else if (c2 >= '0'.codeUnitAt(0) && c2 <= '9'.codeUnitAt(0)) {
                    argb[i] |= (c2 - '0'.codeUnitAt(0));
                }
            }
        }
        color = (argb[0] << 24) | (argb[1] << 16) | (argb[2] << 8) | argb[3];

        return color;
    }

    //将int转颜色值
    static String? colorToString(int color) {
        return sprintf("%08x", [color]);
    }

    //获取颜色的alpha信息
    static int getAlpha(int color) {
        return color >> 24 & 0xff;
    }

    //获取颜色的r值
    static int getR(int color) {
        return color >> 16 & 0xff;
    }

    //获取颜色的g值
    static int getG(int color) {
        return color >> 8 & 0xff;
    }

    //获取颜色的b值
    static int getB(int color) {
        return color & 0xff;
    }

    //将argb转换成int颜色值
    // static int getColor(int a, int r, int g, int b) {
    //     return (a << 24) | (r << 16) | (g << 8) | b;
    // }

    //重新设置颜色的透明度
    // static int getAlphaColor(int color, int alpha) {
    //     return (color & 0xffffff) | ((alpha << 24));
    // }

//重新设置颜色的透明度
    static Color getAlphaColor(Color color, int alpha) {
        return Color((color.value & 0xffffff) | ((alpha << 24)));
    }
    


   
}
