class TypeDownload{
  const TypeDownload._(this.value);
  final String value;
  static const TypeDownload draftPdf = TypeDownload._("/draftPdf.pdf");
  static const TypeDownload AttachDraftPdf = TypeDownload._("/attachDraftPdf.pdf");
  static const TypeDownload attachmentPdf = TypeDownload._("/attachmentPdf.pdf");
  static const TypeDownload attachmentDOC = TypeDownload._("/attachmentDoc.doc");
  static const TypeDownload attachmentDOCX = TypeDownload._("/attachmentDocx.docx");
  static const TypeDownload attachmentPPT = TypeDownload._("/attachmentPpt.ppt");
  static const TypeDownload attachmentPPTX = TypeDownload._("/attachmentPptx.pptx");
  static const TypeDownload attachmentRTF = TypeDownload._("/attachmentRtf.rtf");
  static const TypeDownload attachmentTXT = TypeDownload._("/attachmentTxt.txt");
  static const TypeDownload attachmentXLS = TypeDownload._("/attachmentXls.xls");
  static const TypeDownload attachmentXLSX = TypeDownload._("/attachmentXlsx.xlsx");
  static const TypeDownload attachmentImage = TypeDownload._("/attachmentImage.png");
  static const TypeDownload signatureImage = TypeDownload._("/signatureImage.png");
  static const TypeDownload viewPdf = TypeDownload._("/viewPdf.pdf");
  static const TypeDownload viewAttachPdf = TypeDownload._("/viewAttachPdf.pdf");
}