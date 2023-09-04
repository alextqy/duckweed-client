import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:mime/mime.dart';

// ignore_for_file: unnecessary_this
class FileHelper {
  final String tokenFileName = 'token';

  bool createFile(String filePath) {
    try {
      if (filePath != '') {
        File file = File(filePath);
        file.createSync(recursive: true);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  // 文件写入
  bool writeFile(String fileName, String content) {
    File file = File(fileName);
    try {
      file.writeAsStringSync(content);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> writeFileAsync(String fileName, String content) async {
    File file = File(fileName);
    try {
      file.writeAsStringSync(content);
    } catch (e) {
      return false;
    }
    return true;
  }

  bool writeFileB(String fileName, List<int> content) {
    File file = File(fileName);
    try {
      file.writeAsBytes(content);
    } catch (e) {
      return false;
    }
    return true;
  }

  // 文件读取
  String readFile(String filePath) {
    File file = File(filePath);
    try {
      String content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  // 文件删除
  bool delFile(String filePath) {
    File file = File(filePath);
    try {
      file.deleteSync();
    } catch (e) {
      return false;
    }
    return true;
  }

  // 文件重命名
  bool renameFile(String filePath, String newName) {
    File file = File(filePath);
    try {
      file.renameSync(newName);
    } catch (e) {
      return false;
    }
    return true;
  }

  // 文件复制
  bool copyFile(String filePath, String newName) {
    File file = File(filePath);
    try {
      file.copySync(newName);
    } catch (e) {
      return false;
    }
    return true;
  }

  // 文件是否存在
  bool fileExists(String filePath) {
    File file = File(filePath);
    return file.existsSync();
  }

  // 文件大小
  int size(String filePath) {
    File file = File(filePath);
    return file.lengthSync();
  }

  // 文件类型
  String? type(String filePath) {
    return lookupMimeType(filePath);
  }

  // 文件夹创建
  bool createDir(String dirPath) {
    Directory dir = Directory(dirPath);
    try {
      dir.createSync(recursive: true);
    } catch (e) {
      return false;
    }
    return true;
  }

  // 文件夹删除
  bool delDir(String dirPath) {
    Directory dir = Directory(dirPath);
    try {
      dir.deleteSync(recursive: true);
    } catch (e) {
      return false;
    }
    return true;
  }

  // 文件夹是否存在
  bool dirExists(String dirPath) {
    Directory dir = Directory(dirPath);
    return dir.existsSync();
  }

  // 是否是文件夹
  bool isDir(String path) {
    return FileSystemEntity.isDirectorySync(path);
  }

  // 获取文件列表
  List<FileSystemEntity> listDir(String dirPath) {
    Directory dir = Directory(dirPath);
    return dir.listSync();
  }

  // 打开文件夹
  void openDir({
    required String dirPath,
    required List<String> type,
    String fileName = '*',
  }) async {
    XTypeGroup xType = XTypeGroup(label: fileName, extensions: type);
    await openFile(
      acceptedTypeGroups: [xType],
      initialDirectory: dirPath,
      confirmButtonText: '',
    );
  }

  // 选择文件
  Future<String?> checkFile({
    required String dirPath,
    required List<String> type,
    String fileName = '*',
  }) async {
    XTypeGroup xType = XTypeGroup(label: fileName, extensions: type);
    XFile? tempPath = await openFile(
      acceptedTypeGroups: [xType],
      initialDirectory: dirPath,
      confirmButtonText: '',
    );
    return tempPath?.path;
  }

  Directory appRoot() {
    return Directory.current;
  }

  // 写入json文件
  bool jsonWrite({String key = '', dynamic value = '', String savePath = 'config.json'}) {
    if (key != '' && savePath != '') {
      try {
        File jsonFile = File(savePath);
        if (!jsonFile.existsSync()) {
          jsonFile.createSync(recursive: true);
        }
        // 读取文件
        String jsonStr = jsonFile.readAsStringSync();
        Map<String, dynamic> jsonStrMap = {};
        if (jsonStr != '') {
          jsonStrMap = jsonDecode(jsonStr);
        }
        jsonStrMap[key] = value;
        jsonFile.writeAsStringSync(jsonEncode(jsonStrMap));
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // 读取json文件
  String jsonRead({String key = '', String filePath = 'config.json'}) {
    File jsonFile = File(filePath);
    if (jsonFile.existsSync()) {
      String jsonStr = jsonFile.readAsStringSync();
      Map<String, dynamic> jsonContent = jsonDecode(jsonStr);
      return jsonContent[key].toString();
    }
    return '';
  }
}
