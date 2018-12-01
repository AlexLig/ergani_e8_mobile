import 'package:ergani_e8/routes/contacts_route.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: ContactsRoute(),
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
