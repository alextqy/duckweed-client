import "dart:io";
import "dart:convert";
import "dart:typed_data";
import "package:app/common/file.dart";
import "package:crypto/crypto.dart" as crypto;
import "package:flutter/material.dart";
import "package:app/interface/common/show_alert_dialog.dart";
import "package:app/common/lang.dart";

class Tools {
  // 当前时间戳
  int timestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  // 时间戳转时间
  String timestampToStr(int timestamp) {
    if (timestamp == 0) return "";
    if (timestamp.toString().length == 10) {
      timestamp *= 1000;
    }
    return DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal().toString().substring(0, 19);
  }

  // 时间转时间戳 1970-01-01 00:00:00.00000
  int strToTimestamp(String timeStr) {
    return DateTime.parse(timeStr).millisecondsSinceEpoch;
  }

  // md5
  String genMD5(String content) {
    Uint8List data = const Utf8Encoder().convert(content);
    crypto.Hash md5 = crypto.md5;
    crypto.Digest digest = md5.convert(data);
    return digest.toString();
  }

  // string -> bytes
  Uint8List encodeU8L(String s) {
    List<int> encodedString = utf8.encode(s);
    int encodedLength = encodedString.length;
    ByteData data = ByteData(encodedLength + 4);
    data.setUint32(0, encodedLength, Endian.big);
    Uint8List bytes = data.buffer.asUint8List();
    bytes.setRange(4, encodedLength + 4, encodedString);
    return bytes;
  }

  // bytes -> string
  String decodeU8L(Uint8List s) {
    return utf8.decode(s);
  }

  String utf8Encode(String s) {
    Utf8Decoder decoder = const Utf8Decoder();
    return decoder.convert(encodeU8L(s));
  }

  String base64En(String s) {
    return base64Encode(utf8.encode(s));
  }

  String base64De(String s) {
    return String.fromCharCodes(base64Decode(s));
  }

  // 字符串转二进制数组
  List<int> toByteList(List<dynamic> data) {
    List<int> dataBit = [];
    for (dynamic element in data) {
      dataBit.add(element as int);
    }
    return dataBit;
  }

  // 二进制数组转二进制
  Uint8List byteListToBytes(List<int> data) {
    return Uint8List.fromList(data);
  }

  // 字符串指定位置插入指定符号
  String stringInsertion(String str, int offs, String ins) {
    String start = str.substring(0, offs);
    start += ins;
    String end = str.substring(offs, str.length);
    return start + end;
  }

  // UDP 客户端
  Future<String> clentUDP(int port) async {
    RawDatagramSocket rawDgramSocket = await RawDatagramSocket.bind("0.0.0.0", port);
    // rawDgramSocket.send(utf8.encode("hello,world!"), InternetAddress("0.0.0.0"), port);
    await for (RawSocketEvent event in rawDgramSocket) {
      if (event == RawSocketEvent.read) {
        return utf8.decode(rawDgramSocket.receive()!.data);
      }
    }
    return "";
  }

  Future<void> socketListen(BuildContext context, int port, int s) async {
    Duration timeoutDuration = Duration(milliseconds: s * 1000);
    RawDatagramSocket rawDgramSocket = await RawDatagramSocket.bind("0.0.0.0", port);
    rawDgramSocket.timeout(timeoutDuration, onTimeout: ((sink) {
      showSnackBar(context, content: Lang().requestTimedOut);
      rawDgramSocket.close();
    })).listen((event) async {
      if (event == RawSocketEvent.read) {
        if (!FileHelper().jsonWrite(key: "server_address", value: utf8.decode(rawDgramSocket.receive()!.data))) {
          showSnackBar(context, content: Lang().operationFailed, backgroundColor: Colors.black);
        } else {
          showSnackBar(context, content: Lang().complete, backgroundColor: Colors.black);
        }
        rawDgramSocket.close();
      }
    });
  }

  // UDP 服务端 (待测)
  // void serverUDP() async {
  //   RawDatagramSocket rawDgramSocket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 8081);
  //   await for (RawSocketEvent event in rawDgramSocket) {
  //     if (event == RawSocketEvent.read) {
  //       // print(utf8.decode(rawDgramSocket.receive()!.data));
  //       rawDgramSocket.send(utf8.encode("UDP Server:already received!"), InternetAddress.loopbackIPv4, 8082);
  //     }
  //   }
  // }
}
