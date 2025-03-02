import 'package:flutter/material.dart';
import 'package:flutter_messiah/src/main/util/component/auth_edit_text.dart';
import 'package:flutter_messiah/src/res/color/palette.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(top: 72),
        padding: EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Create an account"),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Already have an account ?"),
              SizedBox(width: 8,),
              Text(
                "Login",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Palette.kToDark[50]),
              )
            ]),
            SizedBox(
              height: 24,
            ),
            AuthTextFormField(
              hintText: "E-mail",
            ),
            SizedBox(
              height: 8,
            ),
            AuthTextFormField(
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(
              width: Get.width,
              height: 53,
              child: ElevatedButton(
                onPressed: () {
                  // Add your action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Border radius 12px
                  ),
                ),
                child: Text(
                  "Login",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
