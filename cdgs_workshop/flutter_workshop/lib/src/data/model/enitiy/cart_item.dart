import 'package:flutter_workshop/src/data/enum/available_color.dart';
import 'package:flutter_workshop/src/data/enum/available_size.dart';
import 'package:flutter_workshop/src/data/model/remote/product.dart';

class CartItem{
  Product product;
  AvailableSize size;
  AvailableColor color;
  int quantity;
  bool isSelected;

  CartItem(this.product, this.size, this.color, {this.quantity = 1, this.isSelected = false});
}