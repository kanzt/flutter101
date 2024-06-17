import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/resource/theme/theme.dart';

/// Example usage :
/// final GlobalKey<FormState> key = GlobalKey<FormState>();
/// final TextEditingController textController = TextEditingController();
///
/// Form(
///   key: key,
///   child: EditText(
///     controller: textController,
///     isReadOnly: false,
///     suffixIconAsset: EditTextAssets.pencil,
///     suffixIconOnPressed: () {},
///     hintText: "คำใบ้ในการกรอกข้อมูล",
///     validator: (value) {
///       const err = true;
///       if (err == true) {
///         return "ข้อความบอกสาเหตุของ Error";
///       } else {
///         return null;
///       }
///     }
///   ),
/// ),
class EditText extends StatefulWidget {
  const EditText({
    Key? key,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.obscuringCharacter = '●',
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.nextFocusNode,
    this.hintText,
    this.autocorrect = true,
    this.isEnabled,
    this.onTap,
    this.textColor = Colors.black,
    this.isReadOnly = false,
    this.enableSuggestions = true,
    this.height = 48,
    this.width = 327,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.contentPadding =
        const EdgeInsets.only(top: 8, bottom: 8, left: 23, right: 8),
    this.borderRadius = 10.0,
    this.errorMessagePosition = ErrorMessagePosition.none,
    this.inputFormatters,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  final String? labelText;
  final bool? obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? nextFocusNode;
  final FocusNode? focusNode;
  final String? hintText;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool? isEnabled;
  final bool isReadOnly;
  final Color textColor;
  final double height;
  final double width;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final ErrorMessagePosition errorMessagePosition;
  final String obscuringCharacter;
  final Color borderColor;

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  InputState inputState = InputState.none;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (widget.validator != null) {
          final validateResult = widget.validator!(value);
          if (validateResult != null) {
            inputState = InputState.error;
          } else {
            inputState = InputState.normal;
          }
          return validateResult;
        }
        inputState = InputState.normal;
        return null;
      },
      builder: (state) {
        if (inputState == InputState.none) {
          if (state.hasError) {
            inputState = InputState.error;
          } else {
            inputState = InputState.normal;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.height,
              width: widget.width,
              child: TextField(
                inputFormatters: widget.inputFormatters,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                readOnly: widget.isReadOnly,
                enabled: widget.isEnabled,
                onTap: widget.onTap,
                focusNode: widget.focusNode,
                cursorColor: inputState == InputState.error
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                enableSuggestions: widget.enableSuggestions,
                autocorrect: widget.autocorrect,
                textInputAction: widget.nextFocusNode != null
                    ? TextInputAction.next
                    : TextInputAction.done,
                onSubmitted: (value) {
                  if (widget.nextFocusNode != null) {
                    FocusScope.of(context).requestFocus(widget.nextFocusNode);
                  }
                },
                obscureText: widget.obscureText == true,
                obscuringCharacter: widget.obscuringCharacter,
                controller: widget.controller,
                onChanged: (text) {
                  if (inputState == InputState.error) {
                    setState(() {
                      inputState = InputState.normal;
                    });
                  }

                  if (inputState == InputState.normal &&
                      text.isEmpty &&
                      state.hasError) {
                    setState(() {
                      inputState = InputState.error;
                    });
                  }

                  state.didChange(text);
                },
                style: AppTheme.textStyle(
                        languageSize: LanguageSize.size16,
                        languageType: LanguageType.regular)
                    ?.copyWith(
                        color: inputState == InputState.error
                            ? Colors.red
                            : widget.textColor),
                decoration: InputDecoration(
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                        color: inputState == InputState.error
                            ? Colors.red
                            : widget.borderColor),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: inputState == InputState.error
                            ? Colors.red
                            : Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  filled: true,
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  contentPadding: widget.contentPadding,
                  labelStyle: const TextStyle().copyWith(
                    color: inputState == InputState.error
                        ? Colors.red
                        : ColorAssets.hawkesBlue,
                  ),
                  hintStyle: AppTheme.textStyle(
                          languageSize: LanguageSize.size16,
                          languageType: LanguageType.regular)
                      ?.copyWith(
                    color: inputState == InputState.error
                        ? Colors.red
                        : ColorAssets.iron,
                  ),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Visibility(
              visible:
                  widget.errorMessagePosition == ErrorMessagePosition.bottom,
              child: SizedBox(
                height: 24,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      state.errorText ?? '',
                      style: AppTheme.textStyle(
                              languageSize: LanguageSize.size16,
                              languageType: LanguageType.regular)
                          ?.copyWith(color: Colors.red),
                    )),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum ErrorMessagePosition { bottom, none }

enum InputState { error, normal, none }
