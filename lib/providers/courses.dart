import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:modern_adacemy/exceptions/http_exception.dart';
import 'package:modern_adacemy/models/course.dart';

class Courses with ChangeNotifier {
  String _userId;
  String _userToken;

  Courses(this._userId, this._userToken);

  List<Course> _courses = [];

  List<Course> get courses {
    return _courses;
  }

  int get totalCreditHours {
    int totalCredits = 0;
    // Another Solution:
    // for (int i = 0; i < _courses.length; i++) {
    //   totalCredits += _courses[i].creditHours ;
    // }
    _courses.map((course) => totalCredits += course.creditHours).toList();
    return totalCredits;
  }

  Future<void> addCourse(Course course) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/$_userId/courses.json?auth=$_userToken';
    try {
      Response response = await post(url,
          body: json.encode({
            'title': course.title,
            'code': course.code,
            'creditHours': course.creditHours,
          }));
      final decodedResponseBody = json.decode(response.body);
      print(decodedResponseBody);
      if (response.statusCode >= 400) {
        throw HttpException('Http Exception');
      }
      _courses.add(Course(
        id: decodedResponseBody['name'],
        title: course.title,
        code: course.code,
        creditHours: course.creditHours,
      ));
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deleteCourse(String courseId) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/$_userId/courses/$courseId.json?auth=$_userToken';
    try {
      Response response = await delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Http Exception');
      }
      final decodedResponseBody = json.decode(response.body);
      print(decodedResponseBody);
      _courses.removeWhere((course) => course.id == courseId);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> fetchCourses() async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/$_userId/courses.json?auth=$_userToken';

    Response response = await get(url);
    final decodedResponseBody =
        json.decode(response.body) as Map<String, dynamic>;
    print(decodedResponseBody);
    if (response.statusCode >= 400) {
      throw HttpException('Http Exception');
    }
    final List<Course> tempCourses = [];
    decodedResponseBody.forEach((courseId, courseData) {
      tempCourses.add(Course(
        id: courseId,
        title: courseData['title'],
        code: courseData['code'],
        creditHours: courseData['creditHours'],
      ));
    });
    _courses = tempCourses;
    notifyListeners();
  }
}
