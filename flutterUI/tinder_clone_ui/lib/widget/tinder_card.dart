import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone_ui/card_provider.dart';
import 'package:tinder_clone_ui/model/user.dart';

class TinderCard extends StatefulWidget {
  const TinderCard({Key? key, required this.user, required this.isFront})
      : super(key: key);

  final User user;
  final bool isFront;

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? _buildFrontCard() : _buildCard(),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final size = MediaQuery.of(context).size;
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.setScreenSize(size);
      },
    );
  }

  Widget _buildFrontCard() {
    return GestureDetector(
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.endPosition();
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints cons) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = cons.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 100;
          final rotateMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotateMatrix..translate(position.dx, position.dy),
            child: Stack(
              children: [
                _buildCard(),
                _buildStamps(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(widget.user.urlImage),
          fit: BoxFit.cover,
          alignment: const Alignment(-0.8, 0),
        )),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1]),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                _buildName(),
                const SizedBox(
                  height: 8,
                ),
                buildStatus(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Row(
      children: [
        Text(
          widget.user.name,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          "${widget.user.age}",
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildStatus() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        const Text(
          "Recently Active",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _buildStamps() {
    final provider = Provider.of<CardProvider>(context, listen: false);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: "LIKE", opacity: opacity);
        return Positioned(
          child: child,
          top: 64,
          left: 50,
        );
      case CardStatus.dislike:
        final child = buildStamp(
          angle: 0.5,
          color: Colors.red,
          text: "DISLIKE",
          opacity: opacity,
        );
        return Positioned(
          child: child,
          top: 64,
          right: 50,
        );
      case CardStatus.superLike:
        final child = Center(
          child: buildStamp(
            color: Colors.blue,
            text: "SUPER\nLIKE",
            opacity: opacity,
          ),
        );
        return Positioned(
          left: 0,
          right: 0,
          bottom: 128,
          child: child,
        );
      default:
        return Container();
    }
  }

  buildStamp({
    double angle = 0,
    required MaterialColor color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: 4,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
