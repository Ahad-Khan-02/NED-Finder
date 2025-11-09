import 'package:ned_finder/utils/http/http_client.dart';

class AuthService {

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {
      "email": email,
      "password": password,
    };

    return await Http.post("login", data);
  }


  static Future<Map<String, dynamic>> signup({
    required String role,
    required String firstName,
    required String lastName,
    required String homeAddress,
    required String email,
    required String fieldOfStudy,
    required int year,
    required String password,
  }) async {

    final data = {
      "role": role,
      "first_name": firstName,
      "last_name": lastName,
      "home_address": homeAddress,
      "email": email,
      "field_of_study": fieldOfStudy,
      "year": year,
      "password": password
    };

    return await Http.post("signup", data);
  }

}
