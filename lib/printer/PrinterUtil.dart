import 'dart:typed_data';
import 'package:tpsl_printer/printer/wifi_communication.dart';
import 'label_command.dart';

class PrinterUtil{

  void printWifiTspl(int copies, int paperWidth, int pageHeight, Uint8List bitmap, WifiCommunication? wifiCommunication, String str2, String str3) {
          DENSITY printDensity = DENSITY.DNESITY8;
          LabelCommand labelCommand = new LabelCommand();
          labelCommand.addSize(paperWidth, pageHeight);
          labelCommand.addDensity(printDensity);
          labelCommand.addSpeed(SPEED.SPEED4);
          labelCommand.addGap(2);
          labelCommand.addCls();
          labelCommand.addReference(0, 0);
          labelCommand.addBitmap(10, 10, paperWidth, pageHeight, BITMAP_MODE.OVERWRITE, bitmap);
          labelCommand.addStrToCommand("\r\n");
          labelCommand.addStrToCommand("PRINT 1," + copies.toString() + "\r\n");
          wifiCommunication!.sendByte(labelCommand.getCommand());
  }

  void printWifiTSPLTemplate(int i, int paperWidth, int pageHeight, WifiCommunication? wifiCommunication) {
    DENSITY printDensity = DENSITY.DNESITY8;
    LabelCommand labelCommand = new LabelCommand();
    labelCommand.addSize(paperWidth, pageHeight);
    labelCommand.addDensity(printDensity);
    labelCommand.addSpeed(SPEED.SPEED4);
    labelCommand.addGap(1);
    labelCommand.addCls();
    // add template
    labelCommand.addText(0, 0, FONTTYPE.FONT_2, ROTATION.ROTATION_0, FONTMUL.MUL_1, FONTMUL.MUL_1, "DH1234567890");
    labelCommand.addText(0, 30, FONTTYPE.FONT_3, ROTATION.ROTATION_0, FONTMUL.MUL_1, FONTMUL.MUL_1, "20/08/2020");
    labelCommand.addText(0, 60, FONTTYPE.FONT_3, ROTATION.ROTATION_0, FONTMUL.MUL_1, FONTMUL.MUL_1, "Nhuộm lại màu giấy");
    labelCommand.addText(0, 90, FONTTYPE.FONT_3, ROTATION.ROTATION_0, FONTMUL.MUL_1, FONTMUL.MUL_1, "Dich vu them ne Dich vu them ne Dich vu them ne Dich vu them ne 123");
    labelCommand.addText(0, 120, FONTTYPE.FONT_3, ROTATION.ROTATION_0, FONTMUL.MUL_1, FONTMUL.MUL_1, "Ghi chu ne");


    // labelCommand.addQRCode(0, 150, EEC.LEVEL_M, CELL_WIDTH.CELL_WIDTH4, ROTATION.ROTATION_0, "DH1234567890");
    // labelCommand.addText(0, 150, FONTTYPE.FONT_1, ROTATION.ROTATION_0, FONTMUL.MUL_1, FONTMUL.MUL_1, "Ghi chu ne");


    labelCommand.addStrToCommand("\r\n");
    labelCommand.addStrToCommand("PRINT 1," + i.toString() + "\r\n");
    wifiCommunication!.sendByte(labelCommand.getCommand());
  }

  List<int> ByteTo_byte(List<int> vector) {
    int size = vector.length;
    List<int> bArr = [];
    for (int i = 0; i < size; i++) {
      bArr[i] = vector[i].toInt();
    }
    return bArr;
  }

  List<dynamic> splitAry(List<int> bArr, int i) {
    int length = (bArr.length % i == 0 ? bArr.length / i : (bArr.length / i) + 1).toInt();
    List<dynamic> arrayList = [];
    for (int i2 = 0; i2 < length; i2++) {
      List<dynamic> arrayList2 = [];
      int i3 = i2 * i;
      int i4 = 0;
      while (i4 < i && i3 < bArr.length) {
        arrayList2.add(bArr[i3]);
        i4++;
        i3++;
      }
      arrayList.add(arrayList2);
    }
    List<dynamic> objArr = [];
    for (int i5 = 0; i5 < arrayList.length; i5++) {
      List list = arrayList[i5];
      List<int> bArr2 = [];
      for (int i6 = 0; i6 < list.length; i6++) {
        bArr2[i6] = (list[i6]).byteValue();
      }
      objArr[i5] = bArr2;
    }
    return objArr;
  }
}

enum SPEED {
  SPEED1DIV5(1.5),
  SPEED2(2.0),
  SPEED3(3.0),
  SPEED4(4.0);
  const SPEED(this.value);
  final double value;
}