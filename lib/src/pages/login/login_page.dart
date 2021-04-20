import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0XFF36D1Dc),
                    Color(0XFF5B86E5),
                  ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0]
              )
            ),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/cdgs_logo.png',
              width: 200),
              Stack(
                children: [
                  Card(
                    margin: EdgeInsets.only(
                      left: 22,
                      top: 22,
                      right: 22,
                      bottom: 62
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            labelText: 'username',
                            icon: Icon(Icons.person),
                            border: InputBorder.none
                          ),
                        ),
                        Divider(
                          height: 28,
                          indent: 22,
                          endIndent: 22,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'password',
                              icon: Icon(Icons.lock),
                              border: InputBorder.none
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: (){}, child: Text('Login',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),))
                ],
              ),
              Text('Header'),
              Text('Login'),
              Text('LoginButton')
            ],
          ),
        ],
      ),
    );
  }
}
