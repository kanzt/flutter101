import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter101/src/config/app_route.dart';
import 'package:flutter101/src/constants/api.dart';
import 'package:flutter101/src/constants/app_setting.dart';
import 'package:flutter101/src/constants/asset.dart';
import 'package:flutter101/src/model/product_response.dart';
import 'package:flutter101/src/pages/login/background_theme.dart';
import 'package:flutter101/src/service/network.dart';
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
      backgroundColor: Colors.grey[300],
      drawer: CommonDrawer(),
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: FutureBuilder<List<ProductResponse>>(
          future: NetworkService().productAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            final productList = snapshot.data;

            return RefreshIndicator(
              onRefresh: () async {
                /// เรียก setState เพื่อ re-render ใหม่
                setState(() {});
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) => LayoutBuilder(
                  builder: (context, constraint) => ShopListItem(
                    constraint.maxHeight,
                    productList[index],
                    press: () async {
                      /// (ส่งค่าข้ามหน้า) ส่งค่า ProductList ไปหน้า management
                      await Navigator.pushNamed(context, AppRoute.managementRoute,
                          arguments: productList[index]);

                      setState(() {

                      });
                    },
                  ),
                ),
                itemCount: productList.length,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /// สั่ง await รอ managementRoute ทำงานเสร็จ (pop หน้าออก) เพื่อที่เราจะได้ Redraw หน้านี้
          await Navigator.pushNamed(context, AppRoute.managementRoute);
          setState(() {});
        },
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
  final ProductResponse product;

  const ShopListItem(this.maxHeight, this.product, {Key key, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// GestureDetector ใช้กรณีที่ต้องการให้ Widget สามารถกดได้
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
              product.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '\$ ${product.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${product.stock} pieces',
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
    final height = maxHeight * 0.7;
    final productImage = product.image;
    return Stack(
      children: [
        productImage != null && productImage.isNotEmpty
            ? Image.network(
                '${API.IMAGE_URL}/$productImage',
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.asset(
                Asset.noPhotoImage,
                height: height,
                width: double.infinity,
              ),
        // 1 > 0
        //     ? SizedBox()
        //     :
        if (product.stock <= 0)
          Positioned(
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
