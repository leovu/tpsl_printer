/*
* Created by: bangnb
* Created at: 2022/08/24 15:53
*/
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as im;

class LabelUtils{

 static List<int> f1287p0 = [0, 128];

 static List<int> f1288p1 = [0, 64];

 static List<int> f1289p2 = [0, 32];

 static List<int> f1290p3 = [0, 16];

 static List<int> f1291p4 = [0, 8];

 static List<int> f1292p5 = [0, 4];

 static List<int> f1293p6 = [0, 2];

 static List<List<int>> Floyd16x16 = [
   [0, 128, 32, 160, 8, 136, 40, 168, 2, 130, 34, 162, 10, 138, 42, 170],
   [192, 64, 224, 96, 200, 72, 232, 104, 194, 66, 226, 98, 202, 74, 234, 106],
   [48, 176, 16, 144, 56, 184, 24, 152, 50, 178, 18, 146, 58, 186, 26, 154],
   [240, 112, 208, 80, 248, 120, 216, 88, 242, 114, 210, 82, 250, 122, 218, 90],
   [12, 140, 44, 172, 4, 132, 36, 164, 14, 142, 46, 174, 6, 134, 38, 166],
   [204, 76, 236, 108, 196, 68, 228, 100, 206, 78, 238, 110, 198, 70, 230, 102],
   [60, 188, 28, 156, 52, 180, 20, 148, 62, 190, 30, 158, 54, 182, 22, 150],
   [252, 124, 220, 92, 244, 116, 212, 84, 254, 126, 222, 94, 246, 118, 214, 86],
   [3, 131, 35, 163, 11, 139, 43, 171, 1, 129, 33, 161, 9, 137, 41, 169],
   [195, 67, 227, 99, 203, 75, 235, 107, 193, 65, 225, 97, 201, 73, 233, 105],
   [51, 179, 19, 147, 59, 187, 27, 155, 49, 177, 17, 145, 57, 185, 25, 153],
   [243, 115, 211, 83, 251, 123, 219, 91, 241, 113, 209, 81, 249, 121, 217, 89],
   [15, 143, 47, 175, 7, 135, 39, 167, 13, 141, 45, 173, 5, 133, 37, 165],
   [207, 79, 239, 111, 199, 71, 231, 103, 205, 77, 237, 109, 197, 69, 229, 101],
   [63, 191, 31, 159, 55, 183, 23, 151, 61, 189, 29, 157, 53, 181, 21, 149],
   [254, 127, 223, 95, 247, 119, 215, 87, 253, 125, 221, 93, 245, 117, 213, 85]
 ];



 static im.Image toGrayscale(Uint8List bitmap, int width, int height) {
    // im.Image img = im.grayscale(bitmap);
    // int imgWidth = bitmap.width;
    // int imgHeight = bitmap.height;
    // double wScale = width / imgWidth;
    // double hScale = height / imgHeight;
    im.Image img = im.grayscale(im.decodePng(bitmap)!);
    im.Image thumbnail = im.copyResize(
      img,
      width: 250,
      height: img.height * 250 ~/ img.width,
    );
    return thumbnail;
  }

 static Uint8List pixToLabelCmd(Uint8List bArr) {
    int length = bArr.length ~/ 8;
    Uint8List bArr2 = Uint8List(length);
    int i = 0;
    for (int i2 = 0; i2 < length; i2++) {
      bArr2[i2] = (~(f1287p0[bArr[i]] + f1288p1[bArr[i + 1]] + f1289p2[bArr[i + 2]] + f1290p3[bArr[i + 3]] + f1291p4[bArr[i + 4]] + f1292p5[bArr[i + 5]] + f1293p6[bArr[i + 6]] + bArr[i + 7]));
      i += 8;
    }
    return bArr2;
  }

 static Uint8List bitmapToBWPix(im.Image? bitmap, String str) {
   Uint32List iArr = Uint32List(bitmap!.length + 1);
   Uint8List bArr = Uint8List(bitmap!.length + 1);
   iArr = getPixels(bitmap);
   format_K_dither16x16(iArr, bitmap.width, bitmap.height, bArr, str);
   return bArr;
 }

 static Uint32List getPixels(im.Image? bitmap){
    Uint32List arr = Uint32List(bitmap!.length + 1);
    int index = 0;
    for(int rowIndex = 0; rowIndex < bitmap.height; rowIndex++){
      for(int cellIndex = 0; cellIndex < bitmap.width; cellIndex++){
        arr[index] = bitmap.getPixel(cellIndex, rowIndex);
        print(index);
        index++;
      }
    }
    return arr;
 }

 static void format_K_dither16x16(Uint32List iArr, int imgWidth, int imgHeight, Uint8List bArr, String str) {
     int i3 = 0;
     int i4 = 0;
     while (i3 < imgHeight) {
         int i5 = i4;
         for (int i6 = 0; i6 < imgWidth; i6++) {
             if ((iArr[i5] & 255) > (str == "0" ? Floyd16x16[i6 & 15][i3 & 15] : 180)) {
                bArr[i5] = 0;
             } else {
                bArr[i5] = 1;
             }
             i5++;
         }
         i3++;
         i4 = i5;
     }
 }
}