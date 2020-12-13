import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modern_adacemy/exceptions/http_exception.dart';
import 'package:modern_adacemy/utils/constants.dart';

class Auth with ChangeNotifier {
  String _userToken;
  String _userId;

  String get userId {
    return _userId;
  }

  String get userToken {
    return _userToken;
  }

  bool get isAuth {
    return _userToken != null;
  }

  void logoutUser() {
    _userToken = null;
    _userId = null;
    notifyListeners();
  }

  Future<void> saveUserData(
    String fName,
    String lName,
    DateTime birthDate,
    String gender,
  ) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/$_userId/personal_information.json?auth=$_userToken';
    try {
      Response response = await post(url,
          body: json.encode({
            'firstName': fName,
            'lastName': lName,
            'birthDate': birthDate.toIso8601String(),
            'gender': gender,
          }));
      final decodedResponseBody = json.decode(response.body);
      print(decodedResponseBody);
      if (response.statusCode >= 400) {
        throw HttpException('Http Problem');
      }
      print(decodedResponseBody);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> authenticateUser(
    String email,
    String password,
    String url,
  ) async {
    try {
      Response response = await post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final decodedResponseBody = json.decode(response.body);
      if (decodedResponseBody['error'] != null) {
        throw HttpException(decodedResponseBody['error']['message']);
      }
      _userId = decodedResponseBody['localId'];
      _userToken = decodedResponseBody['idToken'];
      print(decodedResponseBody);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$FIREBASE_API_KEY';
    await authenticateUser(email, password, url);
  }

  Future<void> signInUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$FIREBASE_API_KEY';
    await authenticateUser(email, password, url);
  }
}
