enum HttpError {
  C_0,
  C_00_000,
  C_00_001,
  C_00_002,
  C_00_003,
  C_00_004,
  C_00_005,
  C_00_006,
  C_00_007,
  C_00_008,
  C_00_024,
  C_01_001_01,
  C_01_001_02,
  C_01_001_03,
  C_01_001_04,
  C_01_001_05,
  C_01_001_06,
  C_01_001_07,
  C_01_001_08,
  C_01_001_09,
  C_01_001_10,
  C_01_001_11,
  C_01_001_18,
  C_01_001_23,
  C_01_001_24,
  C_01_001_25,
  C_01_001_26,
  C_01_001_27,
  C_01_001_28,
  C_01_001_30,
  C_01_001_31,
  C_01_001_32,
  C_01_001_33,
  C_01_001_36,
  C_01_001_37,
  C_01_001_38,
  C_01_002_01,
  C_01_002_02,
  C_01_002_03,
  C_02_001_01,
  C_02_001_02,
  C_02_001_03,
  C_02_001_04,
  C_02_001_05,
  C_02_001_14,
  C_02_001_15,
  C_02_001_16,
  C_02_001_42,
  C_02_001_43,
  C_02_001_44,
  C_02_001_45,
  C_02_001_46,
  C_02_001_50,
  C_02_002_01,
  C_03_001_01,
  C_03_001_02,
  C_03_001_03,
  C_03_001_04,
  C_03_001_05,
  C_04_001_01,
  C_04_001_02,
  C_04_001_03,
  C_04_001_04,
  C_04_001_05,
  C_06_001_01,
  C_06_001_02,
  C_06_001_03,
  C_06_001_04,
  C_06_001_05,
  C_06_001_06,
  C_06_001_07,
  C_06_001_08,
  C_06_001_09,
  C_06_001_10,
  C_06_001_11,
  C_06_001_12,
  C_06_001_13,
  C_06_001_14,
  C_06_001_15,
  C_06_001_16,
  C_06_001_17,
  C_06_001_18,
  C_06_001_19,
  C_06_001_20,
  C_06_001_21,
  C_06_001_22,
  C_06_001_23,
  C_06_001_24,
  C_06_001_25,
  C_06_001_26,
  C_06_001_27,
  C_06_001_28,
  C_06_001_29,
  C_06_001_30,
  C_06_001_31,
  C_06_001_32,
  C_06_001_33,
  C_06_001_34,
  C_06_001_35,
  C_06_001_36,
  C_06_001_37,
  C_06_001_38,
  C_06_001_39,
  C_06_001_40,
  C_06_001_41,
  C_07_001_01,
  C_07_001_02,
  C_07_001_03,
  C_07_001_04,
  C_07_001_05,
  C_07_001_06,
  C_07_001_07,
  C_08_001_22,
  C_02_001_48,
  C_02_001_52,
  C_02_001_53,
  C_02_001_54,
  C_02_001_55,
  C_02_001_56,
  C_02_001_57,
  C_02_001_58,
  C_02_001_59,
  C_02_001_60,
  C_02_001_61,
  C_02_001_62,
  C_02_001_63,
  C_02_002_00,
}

extension HttpErrorExtension on HttpError {
  String get code {
    switch (this) {
      case HttpError.C_0:
        return '0';
      case HttpError.C_00_000:
        return '00-000';
      case HttpError.C_00_001:
        return '00-001';
      case HttpError.C_00_002:
        return '00-002';
      case HttpError.C_00_003:
        return '00-003';
      case HttpError.C_00_004:
        return '00-004';
      case HttpError.C_00_005:
        return '00-005';
      case HttpError.C_00_006:
        return '00-006';
      case HttpError.C_00_007:
        return '00-007';
      case HttpError.C_00_008:
        return '00-008';
      case HttpError.C_00_024:
        return '00-024';
      case HttpError.C_01_001_01:
        return '01-001-01';
      case HttpError.C_01_001_02:
        return '01-001-02';
      case HttpError.C_01_001_03:
        return '01-001-03';
      case HttpError.C_01_001_04:
        return '01-001-04';
      case HttpError.C_01_001_05:
        return '01-001-05';
      case HttpError.C_01_001_06:
        return '01-001-06';
      case HttpError.C_01_001_07:
        return '01-001-07';
      case HttpError.C_01_001_08:
        return '01-001-08';
      case HttpError.C_01_001_09:
        return '01-001-09';
      case HttpError.C_01_001_10:
        return '01-001-10';
      case HttpError.C_01_001_11:
        return '01-001-11';
      case HttpError.C_01_001_18:
        return '01-001-18';
      case HttpError.C_01_001_23:
        return '01_001_23';
      case HttpError.C_01_001_24:
        return '01_001_24';
      case HttpError.C_01_001_25:
        return '01_001_25';
      case HttpError.C_01_001_26:
        return '01_001_26';
      case HttpError.C_01_001_27:
        return '01_001_27';
      case HttpError.C_01_001_28:
        return '01_001_28';
      case HttpError.C_01_001_30:
        return '01_001_30';
      case HttpError.C_01_001_31:
        return '01_001_31';
      case HttpError.C_01_001_32:
        return '01_001_32';
      case HttpError.C_01_001_33:
        return '01_001_33';
      case HttpError.C_01_001_36:
        return '01_001_36';
      case HttpError.C_01_001_37:
        return '01_001_37';
      case HttpError.C_01_001_38:
        return '01_001_38';
      case HttpError.C_01_002_01:
        return '01-002-01';
      case HttpError.C_01_002_02:
        return '01-002-02';
      case HttpError.C_01_002_03:
        return '01-002-03';
      case HttpError.C_02_001_01:
        return '02-001-01';
      case HttpError.C_02_001_02:
        return '02-001-02';
      case HttpError.C_02_001_03:
        return '02-001-03';
      case HttpError.C_02_001_04:
        return '02-001-04';
      case HttpError.C_02_001_05:
        return '02-001-05';
      case HttpError.C_02_001_14:
        return '02-001-14';
      case HttpError.C_02_001_15:
        return '02-001-15';
      case HttpError.C_02_001_16:
        return '02-001-16';
      case HttpError.C_02_001_42:
        return '02_001_42';
      case HttpError.C_02_001_43:
        return '02_001_42';
      case HttpError.C_02_001_44:
        return '02_001_42';
      case HttpError.C_02_001_45:
        return '02_001_42';
      case HttpError.C_02_001_46:
        return '02_001_46';
      case HttpError.C_02_001_50:
        return '02_001_50';
      case HttpError.C_02_002_01:
        return '02-002-01';
      case HttpError.C_03_001_01:
        return '03-001-01';
      case HttpError.C_03_001_02:
        return '03-001-02';
      case HttpError.C_03_001_03:
        return '03-001-03';
      case HttpError.C_03_001_04:
        return '03-001-04';
      case HttpError.C_03_001_05:
        return '03-001-05';
      case HttpError.C_04_001_01:
        return '04-001-01';
      case HttpError.C_04_001_02:
        return '04-001-02';
      case HttpError.C_04_001_03:
        return '04-001-03';
      case HttpError.C_04_001_04:
        return '04-001-04';
      case HttpError.C_04_001_05:
        return '04-001-05';
      case HttpError.C_06_001_01:
        return '06-001-01';
      case HttpError.C_06_001_02:
        return '06-001-02';
      case HttpError.C_06_001_03:
        return '06-001-03';
      case HttpError.C_06_001_04:
        return '06-001-04';
      case HttpError.C_06_001_05:
        return '06-001-05';
      case HttpError.C_06_001_06:
        return '06-001-06';
      case HttpError.C_06_001_07:
        return '06-001-07';
      case HttpError.C_06_001_08:
        return '06-001-08';
      case HttpError.C_06_001_09:
        return '06-001-09';
      case HttpError.C_06_001_10:
        return '06-001-10';
      case HttpError.C_06_001_11:
        return '06-001-11';
      case HttpError.C_06_001_12:
        return '06-001-12';
      case HttpError.C_06_001_13:
        return '06-001-13';
      case HttpError.C_06_001_14:
        return '06-001-14';
      case HttpError.C_06_001_15:
        return '06-001-15';
      case HttpError.C_06_001_16:
        return '06-001-16';
      case HttpError.C_06_001_17:
        return '06-001-17';
      case HttpError.C_06_001_18:
        return '06-001-18';
      case HttpError.C_06_001_19:
        return '06-001-19';
      case HttpError.C_06_001_20:
        return '06-001-20';
      case HttpError.C_06_001_21:
        return '06-001-21';
      case HttpError.C_06_001_22:
        return '06-001-22';
      case HttpError.C_06_001_23:
        return '06-001-23';
      case HttpError.C_06_001_24:
        return '06-001-24';
      case HttpError.C_06_001_25:
        return '06-001-25';
      case HttpError.C_06_001_26:
        return '06-001-26';
      case HttpError.C_06_001_27:
        return '06-001-27';
      case HttpError.C_06_001_28:
        return '06-001-28';
      case HttpError.C_06_001_29:
        return '06-001-29';
      case HttpError.C_06_001_30:
        return '06-001-30';
      case HttpError.C_06_001_31:
        return '06-001-31';
      case HttpError.C_06_001_32:
        return '06-001-32';
      case HttpError.C_06_001_33:
        return '06-001-33';
      case HttpError.C_06_001_34:
        return '06-001-34';
      case HttpError.C_06_001_35:
        return '06-001-35';
      case HttpError.C_06_001_36:
        return '06-001-36';
      case HttpError.C_06_001_37:
        return '06-001-37';
      case HttpError.C_06_001_38:
        return '06-001-38';
      case HttpError.C_06_001_39:
        return '06-001-39';
      case HttpError.C_06_001_40:
        return '06-001-40';
      case HttpError.C_06_001_41:
        return '06-001-41';
      case HttpError.C_07_001_01:
        return '07-001-01';
      case HttpError.C_07_001_02:
        return '07-001-02';
      case HttpError.C_07_001_03:
        return '07-001-03';
      case HttpError.C_07_001_04:
        return '07-001-04';
      case HttpError.C_07_001_05:
        return '07-001-05';
      case HttpError.C_07_001_06:
        return '07-001-06';
      case HttpError.C_07_001_07:
        return '07-001-07';
      case HttpError.C_08_001_22:
        return '08-001-22';
        case HttpError.C_02_001_48:
        return '02-001-48';
      case HttpError.C_02_001_52:
        return '02-001-52';
      case HttpError.C_02_001_53:
        return '02-001-53';
      case HttpError.C_02_001_54:
        return '02-001-54';
      case HttpError.C_02_001_55:
        return '02-001-55';
      case HttpError.C_02_001_56:
        return '02-001-56';
      case HttpError.C_02_001_57:
        return '02-001-57';
      case HttpError.C_02_001_58:
        return '02-001-58';
      case HttpError.C_02_001_59:
        return '02-001-59';
      case HttpError.C_02_001_60:
        return '02-001-60';
      case HttpError.C_02_001_61:
        return '02-001-61';
      case HttpError.C_02_001_62:
        return '02-001-62';
      case HttpError.C_02_002_00:
        return '02-002-00';
        case HttpError.C_02_001_63:
        return '02-001-63';
    }
  }
}
