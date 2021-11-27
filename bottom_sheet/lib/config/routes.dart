import 'package:bottom_sheet/main.dart';
import 'package:bottom_sheet/pages/basic_persistence_bottom_sheet.dart';
import 'package:bottom_sheet/pages/ecm-improve/ecm_bottom_sheet_page.dart';
import 'package:bottom_sheet/pages/full_persistence_bottom_shhet_page.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const mainRoute = "main";
  static const fullPersistenceBottomSheet = "fullPersistenceBottomSheet";
  static const basicPersistenceBottomSheet = "basicPersistenceBottomSheet";
  static const ecmBottomSheet = "ecmBottomSheet";

  get routes => _routes;

  final _routes = <String, WidgetBuilder>{
    mainRoute: (context) => MyHomePage(),
    fullPersistenceBottomSheet: (context) => FullPersistenceBottomSheetPage(),
    basicPersistenceBottomSheet: (context) => BasicPersistenceBottomSheet(),
    ecmBottomSheet: (context) => EcmBottomSheetPage(),
  };
}

final appRoute = AppRoute();