import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

/*
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

class Worker {
  late Isolate isolate;
  late SendPort sendPort;
  final isolateReady = Completer<void>();
  final Map<Capability, Completer> completers = {};

  Worker() {
    init();
  }

  void dispose() {
    isolate.kill();
  }

  Future<void> init() async {
    /// 创建消息接收器
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();

    /// 监听
    receivePort.listen(handleMessage);
    errorPort.listen(handleMessage);

    /// 创建消息发送器
    isolate = await Isolate.spawn(isolateEntry, receivePort.sendPort, onError: errorPort.sendPort);
  }

  Future reuqest(dynamic param) async {
    await isolateReady.future;
    final completer = Completer();
    final requestId = Capability();
    completers[requestId] = completer;

    print(param);

    // sendPort.send(Request(requestId, message));
    // return completer.future;

    int count = 0;
    while (true) {
      count++;
      String msg = 'notification $count';
      print(msg);
      sendPort.send(Request(requestId, msg));
      sleep(const Duration(seconds: 1));
      if (count >= 3) {
        break;
      }
    }
    return completer.future;
  }

  void handleMessage(dynamic message) {
    if (message is SendPort) {
      sendPort = message;
      isolateReady.complete();
      return;
    }
    if (message is Response) {
      final completer = completers[message.requestId];
      if (completer == null) {
        // print("Invalid request ID received.");
        return;
      } else if (message.success) {
        completer.complete(message.message);
      } else {
        completer.completeError(message.message);
      }
      return;
    }
    throw UnimplementedError("Undefined behavior for message: $message");
  }

  static void isolateEntry(dynamic message) {
    late SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic message) async {
      if (message is Request) {
        sendPort.send(Response.ok(message.requestId, '处理后的消息'));
        return;
      }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }

  void stop() {
    sendPort.send('stop');
    isolate.kill();
  }
}

/// 请求体
class Request {
  /// 当前请求的ID
  final Capability requestId;

  /// 请求的实际消息
  final dynamic message;

  const Request(this.requestId, this.message);
}

/// 回应体
class Response {
  /// 当前相应的ID
  final Capability requestId;

  /// 请求完成状态
  final bool success;

  /// 如果[success]为true 则保存响应消息
  /// 如果[success]为false 则保留错误信息
  final dynamic message;

  const Response.ok(this.requestId, this.message) : success = true;
  const Response.err(this.requestId, this.message) : success = false;
}
*/

/*
void isolateFunction() async {
  print("开始");
  ReceivePort isolateToMainStream = ReceivePort();
  await Isolate.spawn(backgroundTask, isolateToMainStream.sendPort);
  isolateToMainStream.listen((data) {
    print("接收: " + data);
  });
  print("结束");
}

void backgroundTask(SendPort sendPort) {
  for (int i = 0; i < 5; i++) {
    print("处理 $i");
    sleep(const Duration(seconds: 1));
    sendPort.send("$i 完成");
  }
}
*/

class FileHandler {
  Future<Uint8List> readBytes(File file, int position, int length) async {
    RandomAccessFile raf = await file.open(mode: FileMode.read);
    RandomAccessFile content = await raf.setPosition(position);
    Uint8List c = content.readSync(length);
    await raf.close();
    return c;
  }

  Future<bool> writeBytesAppend(File file, int position, Uint8List content) async {
    RandomAccessFile raf = await file.open(mode: FileMode.append);
    RandomAccessFile rafp = await raf.setPosition(position);
    try {
      rafp.writeFrom(content);
    } catch (e) {
      return false;
    }
    return true;
  }
}

class Worker {
  FileHandler fileHelper = FileHandler();
  late String filePath;
  late File file;

  Worker({required this.filePath}) {
    file = File(filePath);
  }

  Future<dynamic> run() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(task, receivePort.sendPort);
    receivePort.listen((data) {
      print("接收: " + data);
    });
  }

  void task(SendPort sendPort) async {
    int i = 0;
    while (true) {
      sendPort.send(i.toString());
      sleep(const Duration(milliseconds: 500));
      i++;
    }

    // int i = 0;
    // int limit = 1024 * 512;
    // FileHandler fileHandler = FileHandler;
    // bool out = false;
    // while (true) {
    //   await fileHandler.readBytes(file, i, limit).then((value) {
    //     if (value.isNotEmpty) {
    //       print(value.length);
    //     } else {
    //       out = true;
    //     }
    //     i += limit;
    //     sleep(const Duration(milliseconds: 100));
    //   });
    //   if (out) break;
    // }
    // exit(0);
  }
}
