import 'package:flutter/material.dart';
import 'package:flutter101/src/config/app_route.dart';
import 'package:flutter101/src/constants/app_setting.dart';
import 'package:flutter101/src/pages/login/background_theme.dart';
import 'package:flutter101/src/view_models/menu_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * หน้า 1 หน้า
 */
class HomePage extends StatefulWidget {
  // HomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CommonDrawer(),
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => ShopListItem(200),
        itemCount: 200,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text('Kantaphat'),
              accountEmail: Text('user@user.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/cdgs_logo.png',
                ),
                // backgroundImage: NetworkImage(
                //     'https://www.beartai.com/wp-content/uploads/2019/08/IronMan-EndgameProfile-426x600.jpg'
                // ),
              ),
              decoration: BoxDecoration(gradient: BackGroundTheme.gradient)),
          ...MenuViewModel()
              .items
              .map((e) => ListTile(
                    onTap: () {
                      e.onTap(context);
                    },
                    leading: Icon(
                      e.icon,
                      color: e.iconColor,
                    ),
                    title: Text(e.title),
                  ))
              .toList(),
          Spacer(),
          ListTile(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove(AppSetting.tokenSetting);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.loginRoute, (route) => false);
            },
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}

class ShopListItem extends StatelessWidget {
  final Function press;
  final double maxHeight;

  const ShopListItem(this.maxHeight, {Key key, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _buildImage(),
            Expanded(
              child: _buildInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildInfo() => Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ชื่อสินค้า',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '\$ ราคาสินค้า',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'จำนวน',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
                )
              ],
            ),
          ],
        ),
      );

  Stack _buildImage() {
    final height = maxHeight - 75;
    final productImage =
        'https://shortrecap.co/wp-content/uploads/2020/05/Catcover_web.jpg';
    return Stack(
      children: [
        productImage != null && productImage.isNotEmpty
            ? Image.network(
                productImage,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'xxx',
                height: height,
                width: double.infinity,
              ),
        1 > 0
            ? SizedBox()
            : Positioned(
                top: 1,
                right: 1,
                child: Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.box,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'out of stock',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
