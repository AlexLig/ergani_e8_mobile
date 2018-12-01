import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/contacts_route.dart';
import 'package:ergani_e8/utilFunctions.dart';
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
        // sliderTheme: SliderThemeData(
        //   activeTrackColor: Colors.blueGrey[700],
        //   inactiveTrackColor: Colors.blueGrey[400],
        //   disabledActiveTrackColor: Colors.grey,
        //   disabledInactiveTrackColor: Colors.grey[300],
        //   activeTickMarkColor: Colors.teal[800],
        //   inactiveTickMarkColor: Colors.teal[500],
        //   disabledActiveTickMarkColor: Colors.grey,
        //   disabledInactiveTickMarkColor: Colors.grey[300],
        //   disabledThumbColor: Colors.grey,
        //   overlayColor: Colors.teal[200],
        //   showValueIndicator: ShowValueIndicator.onlyForDiscrete,
        //   thumbColor: Colors.blueGrey[700],
        //   thumbShape: PaddleSliderValueIndicatorShape(),
        //   valueIndicatorColor: Colors.blueGrey[700],
        //   valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        //   valueIndicatorTextStyle: TextStyle(color: Colors.white),
        // ),
        brightness: Brightness.light,
        disabledColor: Colors.blueGrey,
        unselectedWidgetColor: Colors.grey,
        primaryColor: Colors.blueGrey[700],
        accentColor: Colors.teal[800],
        buttonColor: Colors.teal[800],
        cursorColor: Colors.blueGrey[700],
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
