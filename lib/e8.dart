import 'package:flutter/material.dart';

class E8data {
  String _afmEmployer;
  String _ameEmployer;
  String _afmEmployee;
  
}

class E8form extends StatefulWidget {
  @override
  E8formState createState() => E8formState();
}

class E8formState extends State<E8form> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Form(),
        ),
      );
}
