import 'package:flutter/material.dart';
import 'package:flutter_messiah/src/main/presentation/main/home/home_page_controller.dart';
import 'package:flutter_messiah/src/main/presentation/main/main_page_controller.dart';
import 'package:flutter_messiah/src/main/util/component/tinder_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(),
      builder: (_) {
        return SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLogo(),
                    FaIcon(FontAwesomeIcons.search),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(child: _buildCards(context)),
                const SizedBox(
                  height: 16,
                ),
                // _buildButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Row(
      children: const [
        Icon(
          Icons.local_fire_department_rounded,
          size: 40,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          "Fastwork",
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    final provider = Get.find<HomePageController>();
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDisLike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return Visibility(
      visible: users.isNotEmpty,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                final provider = Get.find<HomePageController>();
                provider.disLike();
              },
              style: ButtonStyle(
                foregroundColor: getColor(Colors.red, Colors.white, isDisLike),
                backgroundColor: getColor(Colors.white, Colors.red, isDisLike),
                side: getBorder(Colors.red, Colors.white, isDisLike),
              ),
              child: Icon(
                Icons.clear,
                color: isDisLike ? Colors.white : Colors.red,
                size: 30,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Get.find<HomePageController>();
              provider.superLike();
            },
            style: ButtonStyle(
              foregroundColor: getColor(Colors.blue, Colors.white, isSuperLike),
              backgroundColor: getColor(Colors.white, Colors.blue, isSuperLike),
              side: getBorder(Colors.blue, Colors.white, isSuperLike),
            ),
            child: Icon(
              Icons.star,
              color: isSuperLike ? Colors.white : Colors.blue,
              size: 60,
            ),
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                final provider = Get.find<HomePageController>();
                provider.like();
              },
              style: ButtonStyle(
                foregroundColor: getColor(Colors.teal, Colors.white, isLike),
                backgroundColor: getColor(Colors.white, Colors.teal, isLike),
                side: getBorder(Colors.green, Colors.white, isLike),
              ),
              child: Icon(
                Icons.favorite,
                color: isLike ? Colors.white : Colors.teal,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCards(BuildContext context) {
    final provider = Get.find<HomePageController>();
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                final provider = Get.find<HomePageController>();
                provider.resetUsers();
              },
              child: Icon(
                Icons.refresh,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
          )
        : Stack(
            children: users
                .map(
                  (user) => TinderCard(user: user, isFront: users.last == user),
                )
                .toList(),
          );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    getColor(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    getBorder(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
