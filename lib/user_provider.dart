import 'package:assignment/models/user_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  List<User> get users => _users;

  Future<void> fetchUsers() async {
    try {
      Dio dio = Dio();
      Response response = await dio.get('https://randomuser.me/api/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        _users = data.map((userData) => User.fromJson(userData)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}
