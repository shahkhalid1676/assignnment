
import 'package:assignment/models/user_model.dart';
import 'package:dio/dio.dart';


class UserController {
  final Dio _dio = Dio();
  int _currentPage = 1;

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get(
        'https://randomuser.me/api/',
        queryParameters: {
          'page': _currentPage,
          'results': 10,
        },
      );

      // Validate the response
      if (response.statusCode == 200 && response.data != null) {
        List<User> fetchedUsers = (response.data['results'] as List)
            .map((userData) => User.fromJson(userData))
            .toList();

        _currentPage++;
        return fetchedUsers;
      } else {
        throw Exception("Unexpected response: ${response.statusCode}");
      }
    } catch (e) {
      // Log error for debugging
      print("Error fetching users: $e");
      throw Exception("Error fetching users: $e");
    }
  }
}
