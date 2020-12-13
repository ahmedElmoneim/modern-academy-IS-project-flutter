import 'package:flutter/material.dart';
import 'package:modern_adacemy/providers/courses.dart';
import 'package:modern_adacemy/providers/person_info.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _fetchData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final personalInfoData = Provider.of<PersonalInfo>(context, listen: false);
    await personalInfoData.fetchUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final personalInfoData = Provider.of<PersonalInfo>(context);
    final coursesData = Provider.of<Courses>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${personalInfoData.personalData['firstName'].toString().toUpperCase()} ${personalInfoData.personalData['lastName'].toString().toUpperCase()}',
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(),
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'First Name',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            personalInfoData.personalData['firstName'] ??
                                'Loading...',
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Last Name',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            personalInfoData.personalData['lastName'] ??
                                'Loading...',
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            personalInfoData.personalData['gender'] ??
                                'Loading...',
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'BirthDate',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            personalInfoData.personalData['birthDate']
                                    .toString() ??
                                'Loading...',
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Credit Hours = ${coursesData.totalCreditHours}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.replay,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        _fetchData();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
