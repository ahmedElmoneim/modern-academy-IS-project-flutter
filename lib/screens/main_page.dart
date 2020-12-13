import 'package:flutter/material.dart';
import 'package:modern_adacemy/global_widgets/nav_drawer.dart';
import 'package:modern_adacemy/models/course.dart';
import 'package:modern_adacemy/providers/courses.dart';
import 'package:modern_adacemy/screens/bottom_bar_screens/home.dart';
import 'package:modern_adacemy/screens/bottom_bar_screens/profile.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItem = 0;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, Object>> _bottomNavBarItems = [
    {
      'title': 'Courses',
      'body': Home(),
    },
    {
      'title': 'Profile',
      'body': Profile(),
    },
  ];

  Course _course = Course(
    id: '',
    title: '',
    code: '',
    creditHours: 0,
  );

  void _saveModalSheetForm() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      final coursesData = Provider.of<Courses>(context, listen: false);
      coursesData.addCourse(_course);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modern Academy'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add Course',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'Title',
                            ),
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Enter the Course Title';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (text) {
                              _course.title = text;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Code',
                              hintText: 'Code',
                            ),
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Enter the Course Code';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (text) {
                              _course.code = text;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Credit Hours',
                              hintText: 'Credit Hours',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (text) {
                              if (int.tryParse(text) == null) {
                                return 'Enter a valid number';
                              } else if (int.parse(text) >= 5) {
                                return 'Courses Credit hours are less than 5 hours';
                              } else if (int.parse(text) <= 0) {
                                return 'Courses Credit hours are more than 0 hours';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (text) {
                              _course.creditHours = int.parse(text);
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          OutlineButton(
                            onPressed: () {
                              _saveModalSheetForm();
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: NavigationSideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedItem,
        type: BottomNavigationBarType.fixed,
        elevation: 25,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: _bottomNavBarItems[0]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: _bottomNavBarItems[1]['title'],
          ),
        ],
        onTap: (newIndex) {
          setState(() {
            _selectedItem = newIndex;
          });
        },
      ),
      body: _bottomNavBarItems[_selectedItem]['body'],
    );
  }
}
