import 'dart:convert';
import 'dart:io';

extension FileUtil on File{
  String get toBase64 => base64Encode(readAsBytesSync());
}