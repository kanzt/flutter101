
import 'package:flutter_starter/src/util/log/cdgs_printer.dart';
import 'package:logger/logger.dart';

final Log = Logger(
  printer: CdgsPrinter(
      colors: true
  ),
);