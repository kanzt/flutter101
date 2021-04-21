// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

List<ProductResponse> productResponseFromJson(String str) =>
    List<ProductResponse>.from(
        json.decode(str).map((x) => ProductResponse.fromJson(x)));

String productResponseToJson(List<ProductResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductResponse {
  ProductResponse({
    this.id,
    this.name,
    this.image,
    this.stock,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String image;
  int stock;
  int price;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        stock: json["stock"],
        price: json["price"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "stock": stock,
    "price": price,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}