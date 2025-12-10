import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../core/api_constants.dart';

class UploadFileService {
  Future<String?> uploadFile(File file) async {
    try {
      final url = Uri.parse(ApiConstants.uploadMediaUrl);

      final request = http.MultipartRequest('POST', url)
        // ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('file', file.path));
      // ..fields['type'] = type;
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final json = jsonDecode(respStr);
      log(json.toString());
      if (response.statusCode == 201 && json['message'] == 'Uploaded') {
        return json['data']['key'];
      } else {
        throw Exception(json['message'] ?? "Upload failed");
      }
    } on http.ClientException catch (_) {
      throw 'Something went wrong';
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
