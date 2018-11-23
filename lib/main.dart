import 'package:ergani_e8/create_employee.dart';
import 'package:ergani_e8/e8home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ERGANI'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.amber,
      height: 300,
      child: Center(
        child: Column(
          children: <Widget>[
            TestButton('E8', EmployeeForm()),
            TestButton(
              'Test',
              E8home(
                afmEmployer: '000011111',
                ameEmployer: '9845376124',
                afmEmployee: '10548480',
              ),
              // commonFinishHour: TimeOfDay(hour: 16, minute: 00),
            ),
          ],
        ),
      ),
    );
  }
}

class TestButton extends StatelessWidget {
  final String title;
  final Widget route;

  TestButton(this.title, this.route);

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
