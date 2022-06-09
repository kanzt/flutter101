import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawer_menu/constant/asset.dart';
import 'package:flutter_drawer_menu/style/theme_text.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _createHeader(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _createDrawerItem(
                      icon: const ImageIcon(
                        AssetImage(Asset.calendar),
                        size: 27,
                      ),
                      text: 'ลงเวลา',
                      onTap: (){
                        if (kDebugMode) {
                          print("Do stuff");
                        }
                      }
                    ),
                    _createDrawerItem(
                      icon: const ImageIcon(
                        AssetImage(Asset.addUser),
                        size: 27,
                      ),
                      text: 'จัดการสิทธิ์',
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Divider(),
                    _createDrawerItem(
                      icon: const ImageIcon(
                        AssetImage(Asset.logout),
                        size: 27,
                      ),
                      text: 'ออกจากระบบ',
                      onTap: (){
                        if (kDebugMode) {
                          print("Do stuff");
                        }
                      }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //   fit: BoxFit.fill,
          //   image: AssetImage('path/to/header_background.png'),
          // ),
          ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Asset.businessMan),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Username", style: ThemeText.ubuntuMedium20),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "000000",
                  style: ThemeText.ubuntuBold16
                      .copyWith(color: const Color(0xFFC5C0C0)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required ImageIcon icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          icon,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                text ?? "",
                style: ThemeText.ubuntuRegular20,
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
