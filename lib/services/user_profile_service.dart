import 'dart:convert';

import 'package:dummyjson/model/user_profile.dart';
import 'package:http/http.dart' as http;

class UserProfileService {
  Future<UserProfile?> fetchUserProfile(int userId) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/user/$userId"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    }
    return null;
  }
}
