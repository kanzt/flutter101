import 'package:flutter/cupertino.dart';

abstract class Languages {
  // // Core
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get hello;

  String get selectYear;

  String get cancel;

  String get agree;

  String get qrScanTitle;

  String get errorPage;

  String get emptyItem;

  String get emptyAttachment;

  String get closeApp;

  String get fileAttachment;

  // item pdf
  String get fileNameItemTitle;

  String get fileSizeItemTitle;

  String get fileTypeItemTitle;

  // Register
  String get hostName;

  String get username;

  String get register;

  String get testConnectionToIFlowSoft;

  // Register success
  String get registerSuccess;

  String get registerSuccessDescription;

  String get login;

  // Register failed
  String get registerFailed;

  String get registerFailedDescription;

  String get ok;

  // Login
  String get changePassword;

  String get eSarabun;

  String get password;

  // item
  String get nameTodoTitle;

  String get numberTodoTitle;

  String get dateTodoTitle;

  // item
  String get dialogWarningTitle;

  String get dialogWarningPressedTitle;

  // ChangePassword
  String get newPassword;

  String get confirmNewPassword;

  String get save;

  // Home page
  String get waitForSign;

  String get waitForOrder;

  String get AcknowledgeNewCircular;

  String get searchBook;

  String get searchCircularBook;

  String get operationList;

  // Bottom Navigation
  String get homePage;

  String get qrcodePage;

  String get settingPage;

  // Role bottom sheet
  String get role;

  // SettingPage
  String get setting;

  String get settingSignature;

  String get settingLogin;

  String get settingPin;

  String get settingHelp;

  String get settingPolicy;

  String get settingVersion;

  String get logout;

  // Setting security
  String get changePin;

  String get enabledBiometric;

  String get invalidPasscodePleaseTryAgain;

  String get changePinCodeSuccess;

  //qr
  String get qrTitle;

  String get qrDetail;

  String get btnQrTitle;

  // Signature preview
  String get storeESignature;

  // Signature setting
  String get clearSignature;

  String get createSignature;

  String get newSignature;

  String get touchToSign;

  //pendingTitle
  String get pendingListTitle;

  String get searchListHint;

  // รอสั่งการ
  String get orderListTitle;

  String get bookInformation;

  String get bookDetail;

  // รับทราาบหนังสือเวียนใหม่
  String get acceptListTitle;

  String get draftPdf;

  String get signPdf;

  String get comment;

  // รอลงนาม
  String get bookPathAndOperation;

  String get eSign;

  // order/sign_page.dart
  String get bookNo;

  String get signDate;

  String get signTopic;

  String get signLevel;

  String get signPosition;

  String get certificate;

  String get certificatePassword;

  String get useDefaultSignature;

  String get useNewSignature;

  // order/comment_page.dart
  String get commentDocument;

  String get year;

  String get bookType;

  String get from;

  String get to;

  String get topic;

  String get order;

  String get saveTheOrderOffer;

  String get conclusion;

  String get searchListTitle;

  String get acceptCircular;

  String get acceptBook;

  String get askForAcceptCircularBook;

  String get acceptBookSuccess;

  String get datedBook;

  String get upToDate;

  String get search;

  String get clearFilter;

  String get bookSearch;

  String get movementTable;

  String get pathDiagram;

  String get registerValidateMessage;

  String get registerErrorMessage;

  String get errorNoConnection;

  String get tryAgain;

  String get pleaseInsertHostName;

  String get testConnectionSarabun;

  String get connectSuccess;

  String get connectFailed;

  String get loginValidateMessage;

  String get cantLogin;

  String get greeting;

  String get saveData;

  String get confirmSaveSignature;

  String get confirmSaveComment;

  String get cameraPermissionTitle;

  String get cameraPermission;

  String get saveSignatureSuccess;

  String get signatureIsRequired;

  String get waitForSignNotFound;

  String get circularBookNotFound;

  String get waitForOrderNotFound;

  String get signPositionIsRequired;

  String get certificatePasswordIsRequired;

  String get sendRemarkIsRequired;

  String get signatureIsRequired2;

  String get confirmSignSave;

  String get signatureNotFoundTitle;

  String get signatureNotFoundDetail;

  String get saveSignatureFailed;

  String get saveWaitForCommandFailed;

  String get saveESignatureSuccess;

  String get saveWaitForCommandSuccess;

  String get errorQrScan;

  String get fileTypeError;

  String get noApplicationTitle;

  String get noApplicationDetail;

  String get commentIsRequired;

  String get nameFilePath;

  String get listOverLimit;

  String get startDateMustBeforeEndDate;

  String get startDateIsRequired;

  String get endDateIsRequired;

  String get bookNotFound;

  String get noMovementTable;

  String get itemMovementDateSend;
  String get itemMovementTo;
  String get itemMovementDateReceive;
  String get itemMovementOrgName;
  String get itemMovementStatus;

  String get office;

  String get askFaceScanMessage;
  String get askFingerprintMessage;
  String get allowButtonLabel;
  String get skipLabel;
  String get passcodeValidateLabel;
  String get forgotPasscodeLabel;
}
