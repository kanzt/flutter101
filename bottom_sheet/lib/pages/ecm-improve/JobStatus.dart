import 'package:flutter/material.dart';

import 'JobStatusEnum.dart';

class JobStatus {
  String? code;
  String? fullText;
  Color? color;
  Color? backgroundColor;

  JobStatus.fromCode(String code) {
    late JobStatusEnum jobStatusEnum;

    if (code == JobStatusEnum.OP.code) {
      jobStatusEnum = JobStatusEnum.OP;
    } else if (code == JobStatusEnum.FU.code) {
      jobStatusEnum = JobStatusEnum.FU;
    } else if (code == JobStatusEnum.OB.code) {
      jobStatusEnum = JobStatusEnum.OB;
    } else if (code == JobStatusEnum.AC.code) {
      jobStatusEnum = JobStatusEnum.AC;
    } else if (code == JobStatusEnum.CN.code) {
      jobStatusEnum = JobStatusEnum.CN;
    } else if (code == JobStatusEnum.CA.code) {
      jobStatusEnum = JobStatusEnum.CA;
    } else if (code == JobStatusEnum.REDIRECT.code) {
      jobStatusEnum = JobStatusEnum.REDIRECT;
    }

    this.code = jobStatusEnum.code?.toUpperCase();
    this.color = jobStatusEnum.color;
    this.backgroundColor = jobStatusEnum.backgroundColor;
    this.fullText = jobStatusEnum.fullText;
  }

  JobStatus.fromJobStatusEnum(JobStatusEnum jobStatusEnum) {
    this.code = jobStatusEnum.code?.toUpperCase();
    this.color = jobStatusEnum.color;
    this.backgroundColor = jobStatusEnum.backgroundColor;
    this.fullText = jobStatusEnum.fullText;
  }
}
