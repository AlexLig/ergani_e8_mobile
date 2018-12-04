import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class EmployerListTile extends StatelessWidget {
  final Employer employer;
  String textValue;
  EmployerListTile({Key key, this.employer}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    textValue = employer.ame == null
        ? 'ΑΦΜ: ${employer.afm}'
        : 'ΑΦΜ: ${employer.afm} ΑΜΕ: ${employer.ame}';
    return ListTile(
      title: Text(employer.name ?? 'Εργοδότης'),
      subtitle: Text(textValue),
    );
  }
}
