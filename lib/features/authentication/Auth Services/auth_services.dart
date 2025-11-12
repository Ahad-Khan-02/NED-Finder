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
  required String fullname,
  required String email,
  required String fieldOfStudy,
  required int year,
  required String password,
}) async {

  final data = {
    "role": role,
    "fullname": fullname,
    "email": email,
    "field_of_study": fieldOfStudy,
    "year": year,
    "password": password
  };

  return await Http.post("signup", data);
}


}
