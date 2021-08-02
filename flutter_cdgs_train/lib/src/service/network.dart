import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter101/src/constants/api.dart';
import 'package:flutter101/src/model/product_response.dart';
import 'package:http_parser/http_parser.dart';

class NetworkService {
  NetworkService._internal();

  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  static final Dio _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions) async {
          requestOptions.baseUrl = API.BASE_URL;
          requestOptions.connectTimeout = 5000;
          requestOptions.receiveTimeout = 3000;
          print(requestOptions.baseUrl);
          print(requestOptions.path);
          return requestOptions;
        },
        onResponse: (Response response) async {
          return response;
        },
        onError: (DioError dioError) async {
          switch (dioError.response.statusCode) {
            case 301:
              return '301';
              break;
            case 401:
              return '401';
              break;
            case 404:
              return '404';
              break;
            default:
              return 'Network failed';
          }
        },
      ),
    );

  // getDemo() async{
  //   final response = await _dio.get('https://d92e1eb74350.jp.ngrok.io/products');
  //   if(response.statusCode == 200){
  //     print(response.data.toString());
  //     return;
  //   }
  //   throw Exception('Network failed');
  // }

  Future<List<ProductResponse>> productAll() async {
    final response = await _dio.get(API.PRODUCT);
    if (response.statusCode == 200) {
      return productResponseFromJson(json.encode(response.data));
    }
    throw Exception('Network failed');
  }

Future<String> addProduct(File imageFile, ProductResponse product) async {
  FormData data = FormData.fromMap({
    'name': product.name,
    'price': product.price,
    'stock': product.stock,
    if (imageFile != null)
      'photo': await MultipartFile.fromFile(
        imageFile.path,
        contentType: MediaType('image', 'jpg'),
      ),
  });

  final response = await _dio.post(API.PRODUCT, data: data);

  if (response.statusCode == 201) {
    return 'Add Successfully';
  }
  throw Exception('Network failed');
}

Future<String> editProduct(File imageFile, ProductResponse product) async {
  FormData data = FormData.fromMap({
    'name': product.name,
    'price': product.price,
    'stock': product.stock,
    if (imageFile != null)
      'photo': await MultipartFile.fromFile(
        imageFile.path,
        contentType: MediaType('image', 'jpg'),
      ),
  });

  final response = await _dio.put('${API.PRODUCT}/${product.id}', data: data);

  if (response.statusCode == 200) {
    return 'Edit Successfully';
  }
  throw Exception('Network failed');
}

// Future<String> deleteProduct(int id) async {
//   final response = await _dio.delete('${API.PRODUCT}/$id');
//
//   if (response.statusCode == 204) {
//     return 'Delete Successfully';
//   }
//   throw Exception('Network failed');
// }
//
// Future<List<Posts>> fetchPosts(int startIndex, {int limit = 10}) async {
//   final url =
//       'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit';
//
//   final Response response = await _dio.get(url);
//   if (response.statusCode == 200) {
//     return postsFromJson(jsonEncode(response.data));
//   }
//   throw Exception('Network failed');
// }
}