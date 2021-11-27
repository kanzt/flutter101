import 'dart:ui';

enum JobStatusEnum {
  ALL,
  OP,
  FU,
  OB,
  AC,
  CN,
  CA,
  MC,
  REDIRECT,
}

extension JobStatusExtension on JobStatusEnum {
  String? get code {
    switch (this) {
      case JobStatusEnum.ALL:
        return null;
      case JobStatusEnum.OP:
        return 'OP';
      case JobStatusEnum.FU:
        return 'FU';
      case JobStatusEnum.OB:
        return 'OB';
      case JobStatusEnum.AC:
        return 'AC';
      case JobStatusEnum.CN:
        return 'CN';
      case JobStatusEnum.CA:
        return 'CA';
        case JobStatusEnum.MC:
        return 'MC';
      case JobStatusEnum.REDIRECT:
        return '07';
      default:
        return null;
    }
  }

  String? get fullText {
    switch (this) {
      case JobStatusEnum.ALL:
        return 'All ';
      case JobStatusEnum.OP:
        return 'Opening ';
      case JobStatusEnum.FU:
        return 'Follow Up';
      case JobStatusEnum.OB:
        return 'Observe ';
      case JobStatusEnum.AC:
        return 'Acting';
      case JobStatusEnum.CN:
        return 'Close Normal';
      case JobStatusEnum.CA:
        return 'Close Abnormal';
      case JobStatusEnum.REDIRECT:
        return 'Redirect';
      default:
        return null;
    }
  }

  Color? get color {
    switch (this) {
      case JobStatusEnum.OP:
        return Color(0xFF2F0282);
      case JobStatusEnum.FU:
        return Color(0xFFFF80AB);
      case JobStatusEnum.OB:
        return Color(0xFF0BBDEF);
      case JobStatusEnum.AC:
        return Color(0xFFE2C404);
      case JobStatusEnum.CN:
        return Color(0xFFCC0000);
      case JobStatusEnum.CA:
        return Color(0xFFFB7D00);
      case JobStatusEnum.REDIRECT:
        return Color(0xFF12C16B);
      default:
        return null;
    }
  }

  Color? get backgroundColor {
    switch (this) {
      case JobStatusEnum.OP:
        return Color(0x0D2F0282);
      case JobStatusEnum.FU:
        return Color(0x0DFF80AB);
      case JobStatusEnum.OB:
        return Color(0x0D0BBDEF);
      case JobStatusEnum.AC:
        return Color(0x0DE2C404);
      case JobStatusEnum.CN:
        return Color(0x0DCC0000);
      case JobStatusEnum.CA:
        return Color(0x0DFB7D00);
      case JobStatusEnum.REDIRECT:
        return Color(0x0D12C16B);
      default:
        return null;
    }
  }
}
