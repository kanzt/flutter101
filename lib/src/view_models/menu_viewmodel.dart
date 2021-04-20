import 'package:flutter/material.dart';

class Menu {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function(BuildContext context) onTap;

  const Menu({
    this.title,
    this.icon,
    this.iconColor = Colors.grey,
    this.onTap,
  });
}

class MenuViewModel {
  MenuViewModel();

  List<Menu> get items => <Menu>[
    Menu(
      title: 'Profile',
      icon: Icons.person,
      iconColor: Colors.red,
      onTap: (context) {
        //todo
      },
    ),
    Menu(
      title: 'Map',
      icon: Icons.map,
      iconColor: Colors.green,
      onTap: (context) {
        //todo
      },
    ),
    Menu(
      title: 'Dashboard',
      icon: Icons.dashboard,
      iconColor: Colors.yellow,
      onTap: (context) {
        //todo
      },
    ),
    Menu(
      title: 'Timeline',
      icon: Icons.timeline,
      iconColor: Colors.blue,
      onTap: (context) {
        //todo
      },
    ),
    Menu(
      title: 'Settings',
      icon: Icons.settings,
      iconColor: Colors.orange,
      onTap: (context) {
        //todo
      },
    ),
  ];
}