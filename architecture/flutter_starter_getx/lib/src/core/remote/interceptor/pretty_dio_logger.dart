import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter/src/core/remote/interceptor/ansi_color.dart';
import 'package:flutter_starter/src/core/remote/interceptor/log_level_enum.dart';

class PrettyDioLogger extends Interceptor {
  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  /// Set log color
  final infoColor = getLevelColor(Level.info);

  final errorColor = getLevelColor(Level.error);

  PrettyDioLogger(
      {this.request = true,
      this.requestHeader = false,
      this.requestBody = false,
      this.responseHeader = false,
      this.responseBody = true,
      this.error = true,
      this.maxWidth = 90,
      this.compact = true,
      this.logPrint = print});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      if (request) {
        _printRequestHeader(options);
      }
      if (requestHeader) {
        _printMapAsTable(
          options.queryParameters,
          infoColor,
          header: 'Query Parameters',
        );
        final requestHeaders = <String, dynamic>{};
        requestHeaders.addAll(options.headers);
        requestHeaders['contentType'] = options.contentType?.toString();
        requestHeaders['responseType'] = options.responseType.toString();
        requestHeaders['followRedirects'] = options.followRedirects;
        requestHeaders['connectTimeout'] = options.connectTimeout;
        requestHeaders['receiveTimeout'] = options.receiveTimeout;
        _printMapAsTable(
          requestHeaders,
          infoColor,
          header: 'Headers',
          isPrintBottomLine: false,
        );
        _printMapAsTable(
          options.extra,
          infoColor,
          header: 'Extras',
          isPrintBottomLine: false,
        );
      }
      if (requestBody && options.method != 'GET') {
        final dynamic data = options.data;
        if (data != null) {
          if (data is Map) {
            _printMapAsTable(
              options.data as Map?,
              infoColor,
              header: 'Body',
            );
            log(json.encode(data));
          }
          if (data is FormData) {
            final formDataMap = <String, dynamic>{}
              ..addEntries(data.fields)
              ..addEntries(data.files);
            _printMapAsTable(
              formDataMap,
              infoColor,
              header: 'Form data | ${data.boundary}',
            );
          }
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      if (error) {
        if (err.type == DioErrorType.response) {
          final uri = err.response?.requestOptions.uri;
          _printBoxed(
            header:
                'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
            text: uri.toString(),
            color: errorColor,
          );
          if (err.response != null && err.response?.data != null) {
            logPrint(errorColor('╔ ${err.type.toString()}'));
            _printResponse(err.response!, errorColor);
          }
          _printLine(pre: '╚', color: errorColor);
          logPrint(errorColor(''));
        } else {
          _printBoxed(
            header: 'DioError ║ ${err.type}',
            text: err.message,
            color: errorColor,
          );
        }
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _printResponseHeader(response);
      if (responseHeader) {
        final responseHeaders = <String, String>{};
        response.headers
            .forEach((k, list) => responseHeaders[k] = list.toString());
        _printMapAsTable(
          responseHeaders,
          infoColor,
          header: 'Headers',
          isPrintBottomLine: false,
        );
      }

      if (responseBody) {
        logPrint(infoColor('╔ Body'));
        logPrint(infoColor('║'));
        _printResponse(response, infoColor);
        logPrint(infoColor('║'));
        _printLine(pre: '╚', color: infoColor);
        if (response.data != null) {
          if (response.data is Map) {
            log(json.encode(response.data));
          }
        }
      }
    }
    super.onResponse(response, handler);
  }

  void _printBoxed(
      {String? header,
      String? text,
      bool isPrintBottomLine = true,
      required AnsiColor color}) {
    logPrint(color(''));
    _printLine(pre: '╔', suf: '╗', color: color);
    logPrint(color('╔╣ $header'));
    logPrint(color('║  $text'));
    if (isPrintBottomLine) {
      _printLine(pre: '╚', color: color);
    }
  }

  void _printResponse(Response response, AnsiColor color) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map, color);
      } else if (response.data is List) {
        logPrint(color('║${_indent()}['));
        _printList(response.data as List, color);
        logPrint(color('║${_indent()}['));
      } else {
        _printBlock(response.data.toString(), color);
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header:
            'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
        text: uri.toString(),
        isPrintBottomLine: false,
        color: infoColor);
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(
        header: 'Request ║ $method ',
        text: uri.toString(),
        isPrintBottomLine: false,
        color: infoColor);
  }

  void _printLine(
          {String pre = '', String suf = '╝', required AnsiColor color}) =>
      logPrint(color('$pre${color('═' * maxWidth)}${color(suf)}'));

  void _printKV(String? key, Object? v, AnsiColor color) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(color(pre));
      _printBlock(msg, color);
    } else {
      logPrint(color('$pre$msg'));
    }
  }

  void _printBlock(String msg, AnsiColor color) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint(color((i >= 0 ? '║ ' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length))));
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data,
    AnsiColor color, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var _tabs = tabs;
    final isRoot = _tabs == initialTab;
    final initialIndent = _indent(_tabs);
    _tabs++;

    if (isRoot || isListItem) logPrint(color('║$initialIndent{'));

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logPrint(
              color('║${_indent(_tabs)} "$key": $value${!isLast ? ',' : ''}'));
        } else {
          logPrint(color('║${_indent(_tabs)} "$key": {'));
          _printPrettyMap(value, tabs: _tabs, color);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logPrint(color('║${_indent(_tabs)} "$key": ${value.toString()}'));
        } else {
          logPrint(color('║${_indent(_tabs)} "$key": ['));
          _printList(value, color, tabs: _tabs);
          logPrint(color('║${_indent(_tabs)} ]${isLast ? '' : ','}'));
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(_tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            if (i == 0) {
              logPrint(color(
                  '║${_indent(_tabs)} "$key": ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}'));
            } else {
              logPrint(color(
                  '║${_indent(_tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}'));
            }
          }
        } else {
          logPrint(
              color('║${_indent(_tabs)} "$key": $msg${!isLast ? ',' : ''}'));
        }
      }
    });

    logPrint(color('║$initialIndent}${isListItem && !isLast ? ',' : ''}'));
  }

  void _printList(List list, AnsiColor color, {int tabs = initialTab}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logPrint(color('║${_indent(tabs)}  $e${!isLast ? ',' : ''}'));
        } else {
          _printPrettyMap(
            e,
            color,
            tabs: tabs + 1,
            isListItem: true,
            isLast: isLast,
          );
        }
      } else {
        logPrint(color('║${_indent(tabs + 2)} $e${isLast ? '' : ','}'));
      }
    });
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(
    Map? map,
    AnsiColor color, {
    String? header,
    bool isPrintBottomLine = true,
  }) {
    if (map == null || map.isEmpty) return;
    logPrint(color('╔ $header '));

    if (header == "Body") {
      _printPrettyMap(map, color);
    } else {
      map.forEach((dynamic key, dynamic value) =>
          _printKV(key.toString(), value, color));
    }

    if (isPrintBottomLine) {
      _printLine(pre: '╚', color: color);
    }
  }
}
