import 'dart:convert';

import 'package:http/http.dart' as http;

class Client {
  final String _uri;

  const Client(this._uri);

  Future<http.Response> get(String url) async {
    try {
      final response = await http.get(_uri + url);
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<http.Response> post(
    String url, {
    Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(_uri + url, body: jsonEncode(body));
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<http.Response> patch(
    String url, {
    Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.patch(_uri + url, body: jsonEncode(body));
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<http.Response> delete(String url) async {
    try {
      final response = await http.delete(_uri + url);
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

const FirebaseClient = Client('https://flutter-shop-app-5ac51.firebaseio.com');
