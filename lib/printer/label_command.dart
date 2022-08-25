/*
* Created by: bangnb
* Created at: 2022/08/23 16:56
*/
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as im;
import 'package:convert/convert.dart';
import 'package:tpsl_printer/printer/PrinterUtil.dart';

class LabelCommand{
  String DEBUG_TAG = "LabelCommand";
  List<int> Command = [];
  String StringCommand = "";

  LabelCommand() {
    this.Command = [];
  }

  /*
  * This command clears the image buffer.
  * CLS
  * Note:
  * This command must be placed after SIZE command.
  */
  void addCls() {
    addStrToCommand("CLS\r\n");
  }

  /*
   * This command defines the label width and length.
   * SIZE m mm,n mm
   */
  void addSize(int width, int height) {
    print("addSize");
    addStrToCommand("SIZE $width mm,$height mm\r\n");
    // addStrToCommand("SIZE " + width.toString() + " mm," + height.toString() + " mm\r\n");
  }

  /*
   * This command sets the printing darkness
   * DENSITY n
   * n      0~15
   *        0 : specifies the lightest level
   *        15: specifies the darkest level
   * Note:
   * Default DENSITY setting is 8.
   */
  void addDensity(DENSITY density) {
    addStrToCommand("DENSITY " + density.value.toString() + "\r\n");
  }

  /*
   * This command defines the print speed.
   * SPEED n
   * Printing speed in inch per second
   *
   * Chỉ sử dụng Speed 1.5,2,3,4 vì hỗ trợ được nhiều loại máy in
   */
  void addSpeed(SPEED speed) {
    addStrToCommand("SPEED ${speed.value}\r\n");
  }

  /*
   * Defines the gap distance between two labels.
   * GAP m mm,n mm
   * m:
   *  The gap distance between two labels
   *  0 ≤ m ≤1 (inch), 0 ≤ m ≤ 25.4 (mm)
   *  0 ≤ m ≤5 (inch), 0 ≤ m ≤ 127 (mm) / since V6.21 EZ and later firmware
   * n:
   *  The offset distance of the gap
   *  n ≤ label length (inch or mm)
   */
  void addGap(int gap) {
    addStrToCommand("GAP $gap mm,0 mm\r\n");
  }

  /*
   * Defines the gap distance between two labels.
   * GAP m mm,n mm
   * m:
   *  The gap distance between two labels
   *  0 ≤ m ≤1 (inch), 0 ≤ m ≤ 25.4 (mm)
   *  0 ≤ m ≤5 (inch), 0 ≤ m ≤ 127 (mm) / since V6.21 EZ and later firmware
   * n:
   *  The offset distance of the gap
   *  n ≤ label length (inch or mm)
   */
  void addReference(int xCoordinate, int yCoordinate) {
    addStrToCommand("REFERENCE $xCoordinate,$yCoordinate\r\n");
  }

  /*
   * This command defines the print speed.
   * PRINT m[,n]
   * m Specifies how many sets of labels will be printed.
   *   1 ≤ m ≤ 999999999
   * n Specifies how many copies should be printed for each particular label set.
   *   1 ≤ n ≤ 999999999
   *
   */
  void addPrint(int set, int copies) {
    addStrToCommand("PRINT $set,$copies\r\n");
  }

  /*
   * This command activates the cutter to immediately cut the labels without back feeding the label.
   * CUT
   */
  void addCut() {
    addStrToCommand("CUT\r\n");
  }

  /*
   * This command draws bitmap images (as opposed to BMP graphic files).
   * BITMAP X,Y,width,height,mode,bitmap data…
   * X Specify the x-coordinate
   * Y Specify the y-coordinate
   * width Image width (in bytes)
   * height Image height (in dots)
   * mode Graphic modes listed below:
   * 0: OVERWRITE
   * 1: OR
   * 2: XOR
   * bitmap data Bitmap data
   */
  void addBitmap(int  xCoordinate, int yCoordinate, int width, int height , BITMAP_MODE bitmapMode, Uint8List bitmap) {
    // int xSize = (((width + 7) / 8) * 8).toInt();

    im.Image? image = im.decodePng(bitmap);
    im.Image thumbnail = im.copyResize(
      image!,
      width: width,
      height: height,
    );

    int widthInBytes = thumbnail.width ~/ 8;
    List<Uint8List> data = getData(thumbnail, widthInBytes);
    widthInBytes = data[0].length;
    int heightInDots = data.length;

    // Uint8List bitmapToBWPix = LabelUtils.bitmapToBWPix(image, "0");
    print("BITMAP $xCoordinate,$yCoordinate,$widthInBytes,$heightInDots,${bitmapMode.value},");
    addStrToCommand("BITMAP $xCoordinate,$yCoordinate,$widthInBytes,$heightInDots,${bitmapMode.value},");
    // Uint8List pixToLabelCmd = LabelUtils.pixToLabelCmd(bitmapToBWPix);
    for (Uint8List valueOf in data) {
      this.Command.addAll(valueOf);
    }
  }

  List<Uint8List> getData(im.Image? image, int widthInBytes){
    List<Uint8List> data = [];
    for (int y = 0; y < image!.height; y++) {
      Uint8List row = Uint8List(widthInBytes);
      for (int b = 0; b < widthInBytes; b++) {
        int byte = 0;
        int mask = 128;
        for (int x = b*8; x < (b+1)*8; x++) {
          int color = image.getPixel(x, y);
          if (color < 65) byte = byte ^ mask; // empty dot (1)
          mask = mask >> 1;
        }
        row[b] = byte;
      }
      data.add(row);
    }
    return data;
  }


  /*
  * This command prints text on label.
  * TEXT x,y, " font ",rotation,x-multiplication,y-multiplication,[alignment,] " content "
  * x The x-coordinate of the text
  * y The y-coordinate of the text
  * font Font name
  * rotation  The rotation angle of text
  * x-multiplication Horizontal multiplication, up to 10x
  *     Available factors: 1~10
  * y-multiplication Vertical multiplication, up to 10x
  *     Available factors: 1~10
  * content Content of text string
  * */
  void addText(int xCoordinate, int yCoordinate, FONTTYPE fonttype, ROTATION rotation, FONTMUL fontmul, FONTMUL fontmul2, String content) {
    addStrToCommand("TEXT $xCoordinate,$yCoordinate,\"${fonttype.value}\",${rotation.value},${fontmul.value},${fontmul2.value},\"$content\"\r\n");
  }

  /*
  * This command prints QR code.
  * QRCODE x,y,ECC Level,cell width,mode,rotation,[model,mask,] "content"
  * x The upper left corner x-coordinate of the QR code
  * y The upper left corner y-coordinate of the QR code
  * */
  void addQRCode(int xCoordinate, int yCoordinate, EEC eec, CELL_WIDTH cellWidth, ROTATION rotation, String content) {
    addStrToCommand("QRCODE $xCoordinate,$yCoordinate,${eec.value},${cellWidth.value},A,${rotation.value}," + "\"$content\"" + "\r\n");
  }

  void addStrToCommand(String str) {
    List<int> bArr;
    if (str != "") {
        try {
          bArr = utf8.encode(str);
          StringCommand += hex.encode(bArr);
        } catch (e) {
          print(e);
          bArr = [];
      }

      this.Command.addAll(bArr);
    }
  }

  List<int> getCommand() {
    return this.Command;
  }

  String getStringCommand(){
    return this.StringCommand;
  }
}

enum BITMAP_MODE {
  OVERWRITE(0),
  OR(1),
  XOR(2);
  const BITMAP_MODE(this.value);
  final int value;
}

enum DENSITY {
  DNESITY0(0),
  DNESITY1(1),
  DNESITY2(2),
  DNESITY3(3),
  DNESITY4(4),
  DNESITY5(5),
  DNESITY6(6),
  DNESITY7(7),
  DNESITY8(8),
  DNESITY9(9),
  DNESITY10(10),
  DNESITY11(11),
  DNESITY12(12),
  DNESITY13(13),
  DNESITY14(14),
  DNESITY15(15);
  const DENSITY(this.value);
  final int value;
}

enum FONTTYPE {
  FONT_1("1"),
  FONT_2("2"),
  FONT_3("3"),
  FONT_4("4"),
  FONT_5("5"),
  FONT_6("6"),
  FONT_7("7"),
  FONT_8("8"),
  SIMPLIFIED_CHINESE("TSS24.BF2"),
  TRADITIONAL_CHINESE("TST24.BF2"),
  KOREAN("K");
  const FONTTYPE(this.value);
  final String value;
}

enum ROTATION {
  ROTATION_0(0),
  ROTATION_90(90),
  ROTATION_180(180),
  ROTATION_270(270);
  const ROTATION(this.value);
  final int value;
}

enum FONTMUL {
  MUL_1(1),
  MUL_2(2),
  MUL_3(3),
  MUL_4(4),
  MUL_5(5),
  MUL_6(6),
  MUL_7(7),
  MUL_8(8),
  MUL_9(9),
  MUL_10(10);
  const FONTMUL(this.value);
  final int value;
}
enum EEC {
  LEVEL_L("L"),
  LEVEL_M("M"),
  LEVEL_Q("Q"),
  LEVEL_H("H");
  const EEC(this.value);
  final String value;
}

enum CELL_WIDTH {
  CELL_WIDTH1(1),
  CELL_WIDTH2(2),
  CELL_WIDTH3(3),
  CELL_WIDTH4(4),
  CELL_WIDTH5(5),
  CELL_WIDTH6(6),
  CELL_WIDTH7(7),
  CELL_WIDTH8(8),
  CELL_WIDTH9(9),
  CELL_WIDTH10(10);
  const CELL_WIDTH(this.value);
  final int value;
}
