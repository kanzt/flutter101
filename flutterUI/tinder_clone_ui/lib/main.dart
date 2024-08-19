import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone_ui/card_provider.dart';
import 'package:tinder_clone_ui/widget/tinder_card.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade200, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLogo(),
                const SizedBox(
                  height: 16,
                ),
                Expanded(child: _buildCards()),
                const SizedBox(
                  height: 16,
                ),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: const [
        Icon(
          Icons.local_fire_department_rounded,
          color: Colors.white,
          size: 36,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          "MATCH UP",
          style: TextStyle(
            fontSize: 36,
            color: Colors.white,
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
