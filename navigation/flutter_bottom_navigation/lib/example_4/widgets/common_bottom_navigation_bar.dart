import 'package:flutter/material.dart';

class CommonBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final List<GlobalKey<NavigatorState>> navigatorKeys;
  final List<Widget> childrens;

  late int _size;

  CommonBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.childrens,
    required this.navigatorKeys,
  }) : super(key: key) {
    assert(navigatorKeys.length == childrens.length);

    _size = childrens.length;
  }

  @override
  _CommonBottomNavigationBarState createState() =>
      _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await widget.navigatorKeys[widget.selectedIndex].currentState!.maybePop();

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Stack(
          children: List.generate(widget._size, (index) {
        return _buildOffstageNavigator(index);
      })),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: widget.selectedIndex != index,
      child: widget.childrens[index],
    );
  }
}
