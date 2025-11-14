import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../model/user_dob.dart';
import '../model/user_location.dart';
import '../model/user_name.dart';

class UserApi {
  static Future<List<User>> fetchUsers() async {
    print('fetchUsers called');

    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    final jsonData = jsonDecode(response.body);

    final results = jsonData['results'] as List<dynamic>;

    final users = results.map((e) {
      return User.fromMap(e);

    }).toList();

    return users;
  }
}
