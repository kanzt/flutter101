import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/data/model/remote/category.dart';
import 'package:flutter_workshop/src/data/data.dart';
import 'package:flutter_workshop/src/data/model/remote/product.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  List<Category> categoryList = [];

  List<Product> _persistProductList = [];
  List<Product> productList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void onReady() {
    _fetchProductAndCategory();

    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  void _fetchProductAndCategory() async {
    Get.dialog(
        AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                  margin: const EdgeInsets.only(left: 7),
                  child: const Text("Loading...")),
            ],
          ),
        ),
        barrierDismissible: false);

    final response = await Future.wait([
      AppData.simulateFetchingCategory(),
      AppData.simulateFetchingProduct(),
    ]);

    categoryList = response[0] as List<Category>;
    _persistProductList = response[1] as List<Product>;
    productList = _persistProductList.toList();

    Navigator.of(Get.overlayContext!).pop();

    update();
  }

  Category? getSelectedCategory() {
    try {
      return categoryList.firstWhere((element) => element.isSelected);
    } catch (e) {
      return null;
    }
  }

  void updateCategorySelected(Category category) {
    final selectedCategory = getSelectedCategory();
    selectedCategory?.isSelected = false;
    category.isSelected = true;

    final productListByCategory = searchController.text.isNotEmpty
        ? _filterBySelectedCategory(searchController.text)
        : _getProductsByCategory(category);
    productList = productListByCategory.toList();
    if(productList.isNotEmpty){
      _updateProductSelected(productListByCategory[0]);
    }else{
      update();
    }
  }

  List<Product> _getProductsByCategory(Category category) {
    return _persistProductList
        .where((element) => element.category == category.name)
        .toList();
  }

  void _updateProductSelected(Product product) {
    final selectedProduct = _getSelectedProduct();
    selectedProduct?.isSelected = false;
    product.isSelected = true;
    update();
  }

  Product? _getSelectedProduct() {
    try {
      return productList.firstWhere((element) => element.isSelected);
    } catch (e) {
      return null;
    }
  }

  void search() {
    if (searchController.text.isNotEmpty) {
      final list = _filterBySelectedCategory(searchController.text);
      if(list.isNotEmpty){
        _updateProductSelected(list[0]);
      }
      productList = list;
    } else {
      updateCategorySelected(getSelectedCategory()!);
    }

    update();
  }

  List<Product> _filterBySelectedCategory(String searchValue) {
    return _getProductsByCategory(getSelectedCategory()!)
        .where((element) => element.name.contains(searchValue))
        .toList();
  }
}
