import 'package:flutter/material.dart';
import 'package:modern_adacemy/providers/auth.dart';
import 'package:modern_adacemy/providers/courses.dart';
import 'package:modern_adacemy/providers/person_info.dart';
import 'package:modern_adacemy/screens/authentication_screen.dart';
import 'package:modern_adacemy/screens/main_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, PersonalInfo>(
          create: null,
          update: (context, authData, prevPersonalData) =>
              PersonalInfo(authData.userId, authData.userToken),
        ),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: null,
          update: (context, authData, prevCourses) =>
              Courses(authData.userId, authData.userToken),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Modern Academy',
            theme: ThemeData.dark(),
            home: authData.isAuth ? MainPage() : AuthScreen(),
          );
        },
      ),
    );
  }
}
