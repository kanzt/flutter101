import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/constant/assets.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title, body, btnName;
  final bool showBtn;
  final bool isErrDialog;
  final VoidCallback? handler;
  final VoidCallback? cancelHandler;
  final String assetIcon;
  final Widget? icon;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.body,
    this.handler,
    this.showBtn = true,
    this.isErrDialog = false,
    this.btnName = 'ตกลง',
    this.cancelHandler,
    this.icon,
    this.assetIcon = Assets.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _iconClosed() {
      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  height: 20,
                  width: 20,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Image.asset(
                      Assets.cancel,
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (cancelHandler != null) {
                        if (cancelHandler != null) {
                          cancelHandler!();
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    Widget _confirmBtn() {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 50, right: 50, bottom: 16),
          height: 50,
          child: RawMaterialButton(
            fillColor: isErrDialog
                ? const Color(0xffFF6666)
                : Theme.of(context).primaryColor,
            splashColor:
                isErrDialog ? const Color(0xFFFF6682) : Colors.blueAccent,
            onPressed: () {
              Navigator.pop(context);
              if (handler != null) {
                handler!();
              }
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleText(
                    text: btnName,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _bottomBtn() {
      return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Row(
          children: [
            _confirmBtn(),
          ],
        ),
      );
    }

    Widget _showIcon() {
      return Column(
        children: [
          if (icon != null) icon!,
          if (icon == null)
            Image.asset(
              assetIcon,
              color: isErrDialog ? Colors.red : Theme.of(context).primaryColor,
              height: 50,
              width: 50,
            ),
          const SizedBox(
            height: 14,
          ),
        ],
      );
    }

    Widget _contentBox(BuildContext context) {
      return Container(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 1), blurRadius: 5),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (!isErrDialog) _iconClosed(),
            const SizedBox(
              height: 27,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _showIcon(),
                      TitleText(
                        text: title,
                        textAlign: TextAlign.center,
                        color: Colors.black54,
                      )
                      // Text(
                      //   title,
                      //   style: ThemeText.kanitBold20,
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            if (body.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: TitleText(
                      text: body,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 48,
            ),
            if (showBtn) _bottomBtn(),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }
}
