// ignore_for_file: file_names

import 'package:http/http.dart';
import 'dart:convert';
import 'package:app/common/file.dart';
import 'package:app/model/result_model.dart';

class ResponseHelper {
  Utf8Decoder decoder = const Utf8Decoder();
  String url = FileHelper().jsonRead(key: 'aerver_address');
  int timeout = 10;

  // String token = '';
  // header('sAccess-Control-Allow-Origin:*');
  // header('Access-Control-Allow-Methods:POST');
  // header('Access-Control-Allow-Headers:x-requested-with, content-type');
  // header('Content-type:text/json');
  Map<String, String> postHeaders = {
    'Accept': 'application/json',
    // 'Content-Type': 'application/x-www-form-urlencoded',
    // 'Access-Control-Allow-Origin': '*',
    // 'Access-Control-Allow-Headers': 'x-requested-with, content-type',
  };
  Encoding? postEncoding = Encoding.getByName('utf-8');

  Future<ResultModel> upload({
    required String url,
    required String uri,
    required String filePath,
    String filename = '',
    int id = 0,
    String excelFile = '',
    String attachment = '',
    String contentType = '',
  }) async {
    String fromPathField = '';
    if (excelFile.trim().isNotEmpty) {
      fromPathField = excelFile.trim();
    } else {
      fromPathField = attachment.trim();
    }
    MultipartRequest request = MultipartRequest('post', Uri.parse('http://$url$uri'));
    request.fields['Token'] = FileHelper().readFile('token');
    request.fields['ContentType'] = contentType;
    request.fields['ID'] = id.toString();

    MultipartFile multipartFile = await MultipartFile.fromPath(
      fromPathField,
      filePath,
      filename: filename,
      // contentType: MediaType(contentType, filePath.substring(filePath.lastIndexOf('.') + 1, filePath.length)),
    );
    request.files.add(multipartFile);
    StreamedResponse response = await request.send();
    String respStr = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> respStrMap = jsonDecode(respStr);
    return ResultModel.fromJson(respStrMap);
    // return response;
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
