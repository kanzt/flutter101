import 'package:flutter/material.dart';
import 'package:flutter_messiah/src/main/presentation/main/card_provider.dart';
import 'package:flutter_messiah/src/main/util/component/tinder_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return CardProvider();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80),
            ),
          ),
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildFeed(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // Centered FAB
        floatingActionButton: Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.only(top: 20),
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onPressed: () {
              // Handle action
            },
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFFCC75E),
          // Selected icon color
          unselectedItemColor: Colors.grey,
          // Unselected icon color
          showSelectedLabels: false,
          // Hide labels
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; //
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.userLarge), label: ""),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 24),
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
            Expanded(child: _buildCards()),
            const SizedBox(
              height: 16,
            ),
            // _buildButtons(),
          ],
        ),
      ),
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
          "Messiah",
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
    final provider = Provider.of<CardProvider>(context, listen: false);
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
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
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
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
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
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
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

  _buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
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
