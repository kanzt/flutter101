import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:open_file_playground/pending_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainViewModel extends GetxController {
  var _openResult = 'Unknown';

  String get openResult => _openResult;

  Future<void> openFile() async {
    const filePath = '/storage/emulated/0/Download/sample.pdf';
    final result = await OpenFile.open(filePath);

    _openResult = "type=${result.type}  message=${result.message}";

    update();
  }

  Future<void> downloadAndOpen(String url, String filename) async {
    final file = await _downloadFile(url, filename);

    if (file == null) {
      print("File is null");
      return;
    }

    final result = await OpenFile.open(file.path);

    switch (result.type) {
      case ResultType.done:
        break;
      case ResultType.noAppToOpen:
        showDialog(
            context: Get.context!,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("ไม่พบแอปพลิเคชัน"),
                content: const Text("กดตกลงเพื่อดาวน์โหลด."),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (filename.toLowerCase().contains(".pdf")) {
                        _openPlayStore("com.adobe.reader");
                      } else if (filename.toLowerCase().contains(".docx")) {
                        _openPlayStore("com.microsoft.office.word");
                      }
                    },
                    child: const Text("ตกลง"),
                  ),
                ],
              );
            });
        break;
      case ResultType.fileNotFound:
        break;
      case ResultType.permissionDenied:
        break;
      default:
    }

    _openResult = "type=${result.type}  message=${result.message}";
    update();
  }

  void _openPlayStore(String packageName) {
    try {
      launchUrlString("market://details?id=$packageName");
    } on PlatformException catch (e) {
      launchUrlString(
          "https://play.google.com/store/apps/details?id=$packageName");
    } finally {
      launchUrlString(
          "https://play.google.com/store/apps/details?id=$packageName");
    }
  }

  /// Download file to private storage
  Future<File?> _downloadFile(url, filename) async {
    final storage = await getApplicationDocumentsDirectory();
    final file = File("${storage.path}/$filename");

    if (await file.exists()) {
      return file;
    }

    try {
      Get.dialog(const PendingDialog(), barrierDismissible: false);
      print("Requesting.....");
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      print("Done.....");
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } on Exception catch (e) {
      print(e.toString());
      var errorMessage = "";
      if (e is DioError) {
        switch (e.type) {
          case DioErrorType.connectTimeout:
            errorMessage = connectionTimeoutException;
            break;
          case DioErrorType.other:
            if (DioErrorType.other.name.contains("SocketException")) {
              errorMessage = pleaseConnectToTheInternet;
            } else {
              errorMessage = connectionException;
            }
            break;
          default:
            errorMessage = errorOccurred;
        }
      } else {
        errorMessage = e.toString();
      }
      _openResult = errorMessage;
      update();

      if (await file.exists()) file.delete();
      return null;
    } finally {
      Navigator.of(Get.overlayContext!).pop();
    }

    return file;
  }

  static const validateStartAndEndTime = 'เวลาเข้างานต้องน้อยกว่าเวลาออกงาน';
  static const pleaseConnectToTheInternet = 'กรุณาเชื่อมต่ออินเตอร์เน็ต';
  static const errorOccurred = 'เกิดข้อผิดพลาด';
  static const connectionTimeoutException = 'Connection Timeout Exception';
  static const connectionException = 'Connection Exception';
}
