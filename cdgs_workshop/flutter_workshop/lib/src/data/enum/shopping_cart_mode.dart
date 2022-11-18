enum ShoppingCartMode {
  normal,
  delete,
}

extension ShoppingCartModeExtension on ShoppingCartMode {
  bool get isDeleteMode {
    switch (this) {
      case ShoppingCartMode.normal:
        return false;
      case ShoppingCartMode.delete:
        return true;
      default:
        return false;
    }
  }

  ShoppingCartMode toggle(){
    switch (this) {
      case ShoppingCartMode.normal:
        return ShoppingCartMode.delete;
      case ShoppingCartMode.delete:
        return ShoppingCartMode.normal;
      default:
        return ShoppingCartMode.normal;
    }
  }
}