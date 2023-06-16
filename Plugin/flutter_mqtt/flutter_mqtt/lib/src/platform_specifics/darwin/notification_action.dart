import 'package:flutter/foundation.dart';

import 'notification_action_option.dart';

/// Describes the notification action type.
///
/// This type is used internally.
enum _DarwinNotificationActionType {
  /// Corresponds to the `UNNotificationAction` type defined at
  /// https://developer.apple.com/documentation/usernotifications/unnotificationaction
  plain,

  /// Corresponds to the `UNTextInputNotificationAction` type defined at
  /// https://developer.apple.com/documentation/usernotifications/untextinputnotificationaction
  // text,
}

/// Describes the notification action itself.
///
/// See the official docs at
/// https://developer.apple.com/documentation/usernotifications/unnotificationaction
/// for more details.
class DarwinNotificationAction {
  /// Creates a `UNNotificationAction` for simple actions
  factory DarwinNotificationAction.plain(
    String identifier,
    String title, {
    Set<DarwinNotificationActionOption> options =
        const <DarwinNotificationActionOption>{},
  }) =>
      DarwinNotificationAction._(
        _DarwinNotificationActionType.plain,
        identifier,
        title,
        options: options,
      );

  /// Creates a `UNTextInputNotificationAction` to collect user defined input.
  /// Don't use text action for now
  // factory DarwinNotificationAction.text(
  //   String identifier,
  //   String title, {
  //   required String buttonTitle,
  //   String? placeholder,
  //   Set<DarwinNotificationActionOption> options =
  //       const <DarwinNotificationActionOption>{},
  // }) =>
  //     DarwinNotificationAction._(
  //       _DarwinNotificationActionType.text,
  //       identifier,
  //       title,
  //       buttonTitle: buttonTitle,
  //       placeholder: placeholder,
  //       options: options,
  //     );

  const DarwinNotificationAction._(
    this.type,
    this.identifier,
    this.title, {
    this.options = const <DarwinNotificationActionOption>{},
    this.buttonTitle,
    this.placeholder,
  });

  /// Notification Action type.
  final _DarwinNotificationActionType type;

  /// The unique string that your app uses to identify the action.
  final String identifier;

  /// The localized string to use as the title of the action.
  final String title;

  /// The behaviors associated with the action.
  ///
  /// See [DarwinNotificationActionOption] for available options.
  final Set<DarwinNotificationActionOption> options;

  /// The localized title of the text input button that is displayed to the
  /// user.
  final String? buttonTitle;

  /// The localized placeholder text to display in the text input field.
  final String? placeholder;

  Map<String, Object> toMap() => <String, Object>{
    'identifier': identifier,
    'title': title,
    'options': options
        .map((e) => 1 << e.index) // ignore: always_specify_types
        .toList(),
    'type': describeEnum(type),
    if (buttonTitle != null) 'buttonTitle': buttonTitle!,
    if (placeholder != null) 'placeholder': placeholder!,
  };
}
