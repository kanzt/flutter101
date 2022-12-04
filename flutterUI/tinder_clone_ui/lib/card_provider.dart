import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tinder_clone_ui/model/user.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  bool _isDragging = false;

  bool get isDragging => _isDragging;

  Offset _position = Offset.zero;

  Offset get position => _position;

  Size _screenSize = Size.zero;

  Size get screenSize => _screenSize;

  double _angle = 0;

  double get angle => _angle;

  List<User> _users = [];

  List<User> get users => _users;

  CardProvider() {
    resetUsers();
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = position.dx;
    _angle = 45 * x / screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    // if (status != null) {
    //   Fluttertoast.cancel();
    //   Fluttertoast.showToast(
    //       msg: status.toString().split(".").last.toUpperCase(), fontSize: 36);
    // }

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        disLike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        _resetPosition();
    }
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(position.dx.abs(), position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  /// Force delta = 20 เอาไว้สำหรับเวลาเราเลื่อนการ์ดไปเียง 20 ก็จะให้แสดง Stamp ของ like, dislike and superLike
  CardStatus? getStatus({bool force = false}) {
    final x = position.dx;
    final y = position.dy;
    final forceSuperLike = x.abs() < 20;

    if (kDebugMode) {
      print("x is ${x}, y is ${y}");
    }

    if (force) {
      const delta = 100;
      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      const delta = 20;
      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superLike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }

    return null;
  }

  void _resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  void setScreenSize(Size size) {
    _screenSize = size;
    notifyListeners();
  }

  void resetUsers() {
    _users = [
      User(
        name: "Paper",
        age: 26,
        urlImage:
            'https://scontent.fbkk22-6.fna.fbcdn.net/v/t31.18172-8/16707286_1298873553489657_6354709073298076003_o.jpg?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeE-n9U1sbsjj7gw_iz658yIvYSqZhJX5Gq9hKpmElfkaossoQMoEjaKOpkKZGeLohAs20edOVWJWwglBSG8SVwL&_nc_ohc=VHKoBM2Txn4AX-Fl0Wa&_nc_ht=scontent.fbkk22-6.fna&oh=00_AfDbOZ2zSfwgU0fOhJoFQEbnMLPAfYt_AJPoxCCC7uUwgA&oe=6395FFAF',
      ),
      User(
        name: "Kantaphat",
        age: 26,
        urlImage:
            'https://scontent.fbkk22-6.fna.fbcdn.net/v/t31.18172-8/16707286_1298873553489657_6354709073298076003_o.jpg?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeE-n9U1sbsjj7gw_iz658yIvYSqZhJX5Gq9hKpmElfkaossoQMoEjaKOpkKZGeLohAs20edOVWJWwglBSG8SVwL&_nc_ohc=VHKoBM2Txn4AX-Fl0Wa&_nc_ht=scontent.fbkk22-6.fna&oh=00_AfDbOZ2zSfwgU0fOhJoFQEbnMLPAfYt_AJPoxCCC7uUwgA&oe=6395FFAF',
      )
    ].reversed.toList();

    notifyListeners();
  }

  void _nextCard() async {
    if (users.isEmpty) return;
    await Future.delayed(Duration(milliseconds: 200));
    users.removeLast();
    _resetPosition();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, screenSize.height);
    _nextCard();
    notifyListeners();
  }

  void disLike() {
    _angle = -20;
    _position -= Offset(2 * screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }
}
