import 'dart:convert';
import 'dart:io';
import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class LoginService {
  final HttpClient api;

  LoginService() : api = HttpClient();

  Future<dynamic> getToken(String code) async {
    try {
      String endpoint = EndPoint.login;
      var response = await api.post(endpoint, body: {"code": code});
      print("login-----------------");
      return response;
    } catch (e) {
      print("no login-----------------");
      print(e);
      return "error";
    }
  }
}
