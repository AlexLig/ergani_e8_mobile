import 'package:ergani_e8/routes/contacts_route.dart';
import 'package:ergani_e8/routes/create_employer_route.dart';
import 'package:ergani_e8/utils/database_helper.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ErganiDatabase _erganiDatabase = ErganiDatabase();
  bool _employerExist;
  @override
  void initState() {
    super.initState();

    _erganiDatabase.getEmployerCount().then((employersCount) {
      setState(() {
        _employerExist = employersCount > 0;
      });
    });
  }

  // _checkEmployerExistAndBuild() async {
  //   int employersCount = await _erganiDatabase.getEmployerCount();
  //   setState(() {
  //     _employerExist = employersCount > 0;
  //   });
  //   return await _erganiDatabase.getEmployerCount() > 0 ?
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: child,
          ),
      theme: ThemeData(
        primaryColorDark: Colors.blueGrey[700],
        accentColor: Colors.teal[500],
        buttonColor: Colors.teal[500],
        primaryColor: Colors.blueGrey[500],
        primaryColorLight: Colors.blueGrey[100],
        // primaryTextTheme: Typography.blackMountainView,
        // secondaryText
        dividerColor: Colors.grey[500],
        cursorColor: Colors.blueGrey[700],
        // backgroundColor: Colors.
      ),
      home: FutureBuilder(
        future: _erganiDatabase.getEmployerCount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data > 0)
              return ContactsRoute();
            else
              return EmployerForm();
          } else
            return Container(color: Theme.of(context).canvasColor,);
        },
      ),
    );
  }
}

class TestButton extends StatelessWidget {
  final Widget route;
  final String title;

  TestButton({@required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(this.title),
      onPressed: _onPressedTemporary(context, this.route),
    );
  }
}

Function _onPressedTemporary(context, Widget widget) => () =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
