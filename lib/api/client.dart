import 'dart:convert';

import 'package:http/http.dart' as http;

class Client {
  final String _uri;
  String _token;

  Client(this._uri);

  set token(String token) {
    _token = token;
  }

  String _url(String url) {
    if (_token != null) {
      return _uri + url + '?auth=$_token';
    }
    return _uri + url;
  }

  Future<http.Response> get(String url) async {
    try {
      final response = await http.get(_url(url));
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
      final response = await http.post(_url(url), body: jsonEncode(body));
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
      final response = await http.patch(_url(url), body: jsonEncode(body));
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<http.Response> delete(String url) async {
    try {
      final response = await http.delete(_url(url));
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

// ignore: non_constant_identifier_names
final FirebaseClient = Client('https://flutter-shop-app-5ac51.firebaseio.com');
