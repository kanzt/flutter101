import 'package:flutter_workshop/src/data/model/remote/category.dart';
import 'package:flutter_workshop/src/data/model/remote/product.dart';

class AppData{
  static List<Category> categoryList = [
    Category(
        id: 1,
        name: "Sneakers",
        image: 'assets/shoe_thumb_2.png',
        isSelected: true),
    Category(id: 2, name: "Jacket", image: 'assets/jacket.png'),
    Category(id: 3, name: "Watch", image: 'assets/watch.png'),
    Category(id: 4, name: "Watch", image: 'assets/watch.png'),
  ];

  static List<Product> productList = [
    Product(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/shooe_tilt_1.png',
        category: "Sneakers"),
    Product(
        id: 2,
        name: 'Nike Air Max 97',
        price: 220.00,
        isliked: false,
        image: 'assets/shoe_tilt_2.png',
        category: "Sneakers"),
    Product(
        id: 3,
        name: 'Nike Jacket',
        price: 220.00,
        isliked: false,
        image: 'assets/jacket.png',
        category: "Jacket"),
  ];

  static List<String> showThumbnailList = [
    "assets/shoe_thumb_5.png",
    "assets/shoe_thumb_1.png",
    "assets/shoe_thumb_4.png",
    "assets/shoe_thumb_3.png",
  ];

  static List<Product> cartList = [
    Product(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/small_tilt_shoe_1.png',
        category: "Trending Now"),
    Product(
        id: 2,
        name: 'Nike Air Max 97',
        price: 190.00,
        isliked: false,
        image: 'assets/small_tilt_shoe_2.png',
        category: "Trending Now"),
    Product(
        id: 1,
        name: 'Nike Air Max 92607',
        price: 220.00,
        isliked: false,
        image: 'assets/small_tilt_shoe_3.png',
        category: "Trending Now"),
    Product(
        id: 2,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/small_tilt_shoe_1.png',
        category: "Trending Now"),
  ];

  static updateCategorySelected(Category category){
      final selectedCategory = getSelectedCategory();
      selectedCategory?.isSelected = false;
      category.isSelected = true;

      final productListByCategory = productList.where((element) => element.category == category.name).toList();
      updateProductSelected(productListByCategory[0]);
  }

  static Category? getSelectedCategory(){
    try {
      return categoryList.firstWhere((element) => element.isSelected);
    }catch (e){
      return null;
    }
  }

  static void updateProductSelected(Product product) {
    final selectedProduct = getSelectedProduct();
    selectedProduct?.isSelected = false;
    product.isSelected = true;
  }

  static Product? getSelectedProduct(){
    try {
      return productList.firstWhere((element) => element.isSelected);
    }catch (e){
      return null;
    }
  }

  static double getPrice() {
    double price = 0;
    for (var x in AppData.cartList) {
      price += x.price * x.id;
    }
    return price;
  }

  static Future<List<Product>> simulateFetchingProduct(){
    return Future.delayed(const Duration(seconds: 1), () {
      return productList;
    });
  }

  static Future<List<Category>> simulateFetchingCategory(){
    return Future.delayed(const Duration(seconds: 1), () {
      return categoryList;
    });
  }
}