import 'package:ergani_e8/components/drawer.dart';
import 'package:ergani_e8/routes/contacts_route.dart';

import 'package:ergani_e8/routes/new_employer_route.dart';

import 'package:ergani_e8/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ErganiDatabase _erganiDatabase = ErganiDatabase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subito E8',
      builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          ),
      theme: ThemeData(
        primaryColorDark: Colors.blueGrey[800],
        accentColor: Colors.teal[500],
        buttonColor: Colors.teal[500],
        primaryColor: Colors.blueGrey[700],
        primaryColorLight: Colors.blueGrey[100],
        // primaryTextTheme: Typography.blackMountainView,
        // secondaryText
        dividerColor: Colors.grey[500],
        cursorColor: Colors.blueGrey[700],
        // backgroundColor: Colors.
      ),
      routes: <String, WidgetBuilder>{
        '/contacts': (BuildContext context) => ContactsRoute(),
      },
      home: FutureBuilder(
        future: _erganiDatabase.getEmployerCount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data > 0)
              return ContactsRoute();
            else
              return CreateNewEmployer();
          } else
            return Container(
              color: Theme.of(context).canvasColor,
              // color: Color(0xFF37474f),
            );
        },
      ),
    );
  }
}
