import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/e8/e8home.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';

class E8route extends StatelessWidget {
  final Employee employee;
  final Employer employer;

  E8route({Key key, @required this.employer, @required this.employee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return E8provider(
      employee: employee,
      employer: employer,
      child: E8home(),
    );
  }
}
