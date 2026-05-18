import 'package:dio/dio.dart';
import '../models/item_model.dart';

class ItemRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://6a0ad2e921e445625696aaa2.mockapi.io',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // READ
  Future<List<LostFoundItem>> fetchItems() async {
    try {
      final response = await _dio.get('/items');
      final List data = response.data as List;
      return data.map((e) => LostFoundItem.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // CREATE
  Future<LostFoundItem> createItem(LostFoundItem item) async {
    try {
      final response = await _dio.post('/items', data: item.toJson());
      return LostFoundItem.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // UPDATE
  Future<LostFoundItem> updateItem(String id, LostFoundItem item) async {
    try {
      final response = await _dio.put('/items/$id', data: item.toJson());
      return LostFoundItem.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    try {
      await _dio.delete('/items/$id');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Check your internet.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      default:
        return 'Network error: ${error.message}';
    }
  }
}
