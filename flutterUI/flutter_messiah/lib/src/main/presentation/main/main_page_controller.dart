import 'package:get/get.dart';

class MainPageController extends GetxController {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  onSelectBottomNavigationItem(int index) {
    _currentIndex = index;
    update();
  }
}
