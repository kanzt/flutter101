import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_messiah/model/user.dart';
import 'package:flutter_messiah/src/main/presentation/main/card_provider.dart';
import 'package:flutter_messiah/src/main/util/component/heart_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TinderCard extends StatefulWidget {
  const TinderCard({super.key, required this.user, required this.isFront});

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
                // _buildStamps(),
                // const HeartWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.user.urlImage) as ImageProvider,
            fit: BoxFit.cover,
            alignment: const Alignment(-0.8, 0),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 1],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _operationIcon(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildConnectButton(),
                        _buildName(),
                        const SizedBox(
                          height: 2,
                        ),
                        buildStatus(),
                      ],
                    ),
                    // IconButton(
                    //     color: Colors.white,
                    //     // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                    //     icon: FaIcon(FontAwesomeIcons.triangleExclamation),
                    //     onPressed: () {},
                    // ),
                  ],
                ),
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
        const Text(
          "Bangkok, Thailand",
          style: TextStyle(
            fontSize: 16,
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
    final scale = provider.getScaleSize();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: Colors.green,
          text: "LIKE",
          opacity: opacity,
          scale: scale,
        );
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
            scale: scale,
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
    double scale = 1,
    required MaterialColor color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(12),
                // border: Border.all(
                //   color: color,
                //   width: 4,
                // ),
                ),
            child: const HeartWidget(),
            // child: Text(
            //   text,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     color: color,
            //     fontSize: 48,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  Widget _operationIcon() {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle),
          child: Center(
            child: IconButton(
                color: Colors.white,
                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                icon: FaIcon(FontAwesomeIcons.play),
                onPressed: () {}),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 65,
          height: 65,
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Center(
            child: IconButton(
              color: Color(0xFFFCC75E),
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(FontAwesomeIcons.volumeMute),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            FaIcon(size: 16, FontAwesomeIcons.userPlus),
            SizedBox(width: 4,),
            Text("Follow"),
          ],
        ),
      ),
    );
  }
}
