import 'package:flutter/material.dart';
import 'package:modern_adacemy/providers/courses.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final coursesData = Provider.of<Courses>(context, listen: false);
    coursesData.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);

    return coursesData.courses.length == 0
        ? Center(
            child: Text(
              'No Courses added yet!\nAdd New Courses to see them here',
              textAlign: TextAlign.center,
            ),
          )
        : ListView.separated(
            itemBuilder: (context, i) {
              return Dismissible(
                key: ValueKey(coursesData.courses[i].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: EdgeInsets.only(right: 10),
                  margin: EdgeInsets.all(4),
                  color: Colors.red[700],
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerRight,
                ),
                confirmDismiss: (_){
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Course?'),
                          content: Text(
                              'Are you sure to delete this Course?\nThis will be permanently deleted.'),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('No'),
                            ),
                            FlatButton(
                              onPressed: () {
                                coursesData.deleteCourse(coursesData.courses[i].id);
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      });
                },
                child: ListTile(
                  title: Text(coursesData.courses[i].title),
                  subtitle: Text(coursesData.courses[i].code),
                  leading: Text((i + 1).toString()),
                  trailing: CircleAvatar(
                    child: FittedBox(
                        child: Text(
                      coursesData.courses[i].creditHours.toString(),
                    )),
                  ),
                ),
              );
            },
            separatorBuilder: (context, i) {
              return Divider(
                indent: 16,
                endIndent: 16,
              );
            },
            itemCount: coursesData.courses.length,
          );
  }
}
