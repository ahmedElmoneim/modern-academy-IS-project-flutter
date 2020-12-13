import 'package:flutter/foundation.dart';

class HttpException implements Exception {
  @required
  String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
