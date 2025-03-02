import 'package:flutter/material.dart';
import 'package:flutter_messiah/src/res/color/palette.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    super.key,
    this.hintText,
    this.isPasswordField = false,
  });

  final String? hintText;

  final bool isPasswordField;

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            TextFormField(
              obscuringCharacter: '●',
              obscureText: widget.isPasswordField && isShowPassword,
              enableSuggestions: !widget.isPasswordField,
              autocorrect: !widget.isPasswordField,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                hintText: widget.hintText,
                fillColor: Palette.lightGray,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            if (widget.isPasswordField)
              Positioned(
                bottom: 0,
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    isShowPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        if (widget.isPasswordField)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {},
                child: Text(
                  "Forgot password ?",
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 19,
        ),
      ],
    );
  }
}
