import 'package:flutter/foundation.dart';

class Course {
  String id;
  String title;
  String code;
  int creditHours;

  Course({
    @required this.id,
    @required this.title,
    @required this.code,
    @required this.creditHours,
  });
}
