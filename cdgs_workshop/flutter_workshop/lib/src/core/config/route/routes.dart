import 'package:flutter_workshop/src/presentation/cart/shopping_cart_page.dart';
import 'package:flutter_workshop/src/presentation/detail/product_detail_page.dart';
import 'package:flutter_workshop/src/presentation/login/login_page.dart';
import 'package:flutter_workshop/src/presentation/main/main_page.dart';
import 'package:flutter_workshop/src/presentation/nearby_store/nearby_store_page.dart';
import 'package:flutter_workshop/src/presentation/search_by_image/search_by_image_page.dart';
import 'package:flutter_workshop/src/presentation/setting/setting_page.dart';
import 'package:get/get.dart';

class Routes {
  static const root = "/";
  static const mainPage = "/main";
  static const detailPage = "/detail";
  static const shoppingCartPage = "/shopping-cart";
  static const settingPage = "/setting";
  static const loginPage = "/login";
  static const nearbyStorePage = "/nearby_store";
  static const searchByImagePage = "/search_by_image";

  // static Map<String, WidgetBuilder> getRoute() {
  //   return <String, WidgetBuilder>{
  //     root: (_) => MainPage(),
  //     detailPage: (_) => ProductDetailPage(),
  //     shoppingCartPage: (_) => const ShoppingCartPage(),
  //   };
  // }

  static List<GetPage> getPageRoutes() {
    return [
      GetPage(
        name: root,
        page: () => LoginPage(),
        // transition: Transition.noTransition,
      ),
      GetPage(
        name: mainPage,
        page: () => MainPage(),
      ),
      GetPage(
        name: detailPage,
        page: () => ProductDetailPage(),
      ),
      GetPage(
        name: shoppingCartPage,
        page: () => const ShoppingCartPage(),
      ),
      GetPage(
        name: settingPage,
        page: () => SettingPage(),
      ),
      GetPage(
        name: loginPage,
        page: () => LoginPage(),
      ),
      GetPage(
        name: nearbyStorePage,
        page: () => NearbyStorePage(),
      ),
      GetPage(
        name: searchByImagePage,
        page: () => SearchByImagePage(),
      ),
    ];
  }
}
