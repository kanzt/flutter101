

import 'package:flutter_starter/src/core/remote/enum/type_download.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';

enum AttachType {
  pdf,
  image,
  office,
  txt,
  zip;

  factory AttachType.fromType(String attachType) {
    var type = attachType.toUpperCase();
    switch (type) {
      case "PDF":
        return AttachType.pdf;
      case "JPG":
      case "PNG":
      case "BMP":
      case "TIFF":
      case "JPEG":
      case "TIF":
        return AttachType.image;
      case "TXT":
        return AttachType.txt;
      case "ZIP":
        return AttachType.zip;
      case "PPT":
      case "PPTX":
      case "RTF":
      case "DOC":
      case "DOCX":
      case "XLS":
      case "XLSX":
        return AttachType.office;
      default:
        return AttachType.pdf;
    }
  }
}
extension DownloadType on String{
  TypeDownload get downloadType {
    var type = toUpperCase();
    switch (type) {
      case "PDF":
        return TypeDownload.attachmentPdf;
      case "JPG":
      case "PNG":
      case "BMP":
      case "TIFF":
      case "JPEG":
      case "TIF":
        return TypeDownload.attachmentImage;
      case "TXT":
        return TypeDownload.attachmentTXT;
      case "PPT":
        return TypeDownload.attachmentPPT;
      case "PPTX":
        return TypeDownload.attachmentPPTX;
      case "RTF":
        return TypeDownload.attachmentRTF;
      case "DOC":
        return TypeDownload.attachmentDOC;
      case "DOCX":
        return TypeDownload.attachmentDOCX;
      case "XLS":
        return TypeDownload.attachmentXLS;
      case "XLSX":
        return TypeDownload.attachmentXLSX;
      default:
        return TypeDownload.attachmentPdf;
    }
  }
}
extension AttachTypeExtension on AttachType {
  String get image {
    switch (this) {
      case AttachType.pdf:
        return Assets.pdfType;
      case AttachType.txt:
        return Assets.txtType;
      case AttachType.office:
        return Assets.officeType;
      case AttachType.zip:
        return Assets.zipType;
      case AttachType.image:
        return Assets.imageType;
      default:
        return Assets.pdfType;
    }
  }
}