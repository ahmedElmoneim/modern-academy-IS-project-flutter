import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_adacemy/exceptions/http_exception.dart';

class PersonalInfo with ChangeNotifier {
  String _userId;
  String _userToken;

  PersonalInfo(this._userId, this._userToken);

  Map<String, Object> _personalData = {};

  Map<String, Object> get personalData {
    return _personalData;
  }

  Future<void> fetchUserData() async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/$_userId/personal_information.json?auth=$_userToken';
    try {
      Response response = await get(url);
      final decodedResponseBody =
          json.decode(response.body) as Map<String, dynamic>;
      print(decodedResponseBody);
      if (response.statusCode >= 400) {
        throw HttpException('Http Exception');
      }

      final Map<String, Object> mapValues = decodedResponseBody.values.first;

      Map<String, Object> tempPersonalData = {
        'firstName': '',
        'lastName': '',
        'birthDate': DateTime.now(),
        'gender': '',
      };
      tempPersonalData['firstName'] = mapValues['firstName'];
      tempPersonalData['lastName'] = mapValues['lastName'];
      tempPersonalData['birthDate'] = DateTime.parse(mapValues['birthDate']);
      tempPersonalData['gender'] = mapValues['gender'];

      _personalData = tempPersonalData;

      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}
