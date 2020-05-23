import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/auth_exception.dart';
import 'package:shopapp/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  String _createUrl(String method) {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyB68e4WHW6zm5UJyWyBh2irBcaTZpcB8Hw';
  }

  Future<void> _authenticate(
    String email,
    String password,
    String method,
  ) async {
    final url = _createUrl(method);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final body = jsonDecode(response.body);
      if (body['error'] != null) {
        throw AuthException(body['error']['message']);
      }
    } on AuthException catch (err) {
      throw err;
    } catch (err) {
      throw HttpException(err);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
