import 'package:dio/dio.dart';
import '../models/item_model.dart';

class ItemRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // READ — fetch first 20 posts and treat them as lost/found items
  Future<List<LostFoundItem>> fetchItems() async {
    try {
      final response = await _dio.get('/posts', queryParameters: {'_limit': 20});
      if (response.statusCode == 200) {
        final List data = response.data as List;
        // Alternate type so the list looks realistic
        return data.asMap().entries.map((e) {
          final json = Map<String, dynamic>.from(e.value);
          json['type'] = e.key.isEven ? 'Lost' : 'Found';
          json['status'] = 'Active';
          json['location'] = 'Campus';
          return LostFoundItem.fromJson(json);
        }).toList();
      }
      throw Exception('Unexpected status code');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // CREATE
  Future<LostFoundItem> createItem(LostFoundItem item) async {
    try {
      final response = await _dio.post('/posts', data: item.toJson());
      final json = Map<String, dynamic>.from(response.data);
      // JSONPlaceholder echoes back the body; preserve our extra fields
      json['location'] = item.location;
      json['contactInfo'] = item.contactInfo;
      json['type'] = item.type;
      json['status'] = item.status;
      return LostFoundItem.fromJson(json);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // UPDATE
  Future<LostFoundItem> updateItem(String id, LostFoundItem item) async {
    try {
      // JSONPlaceholder only has ids 1-100; use PUT on /posts/1 as a demo
      final safeId = int.tryParse(id) != null && int.parse(id) <= 100 ? id : '1';
      final response = await _dio.put('/posts/$safeId', data: item.toJson());
      final json = Map<String, dynamic>.from(response.data);
      json['id'] = id; // keep original id
      json['location'] = item.location;
      json['contactInfo'] = item.contactInfo;
      json['type'] = item.type;
      json['status'] = item.status;
      return LostFoundItem.fromJson(json);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    try {
      final safeId = int.tryParse(id) != null && int.parse(id) <= 100 ? id : '1';
      await _dio.delete('/posts/$safeId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with the server.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      default:
        return 'Something went wrong with the network.';
    }
  }
}
