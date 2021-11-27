import 'package:flutter/material.dart';

import 'JobStatus.dart';

class SearchItemModel {
  final String? title;
  final String? subTitle;
  final String? description;
  final JobStatus? jobStatus;
  bool isSelected;

  SearchItemModel({required this.title,
    required this.subTitle,
    required this.description,
    required this.jobStatus,
    this.isSelected = false});

  static createEmpty() {
    return SearchItemModel(title: null,
        subTitle: null,
        description: null,
        jobStatus: null,
        isSelected: false);
  }
}
