import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class EmployerListTile extends StatelessWidget {
  final Employer employer;

  EmployerListTile({this.employer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${employer.name}'),
      subtitle: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text('ΑΦΜ: ${employer.afm}'),
          ),
          employer.hasAme() ? Text('ΑΜΕ: ${employer.ame}') : null,
        ].where(isNotNull).toList(),
      ),
    );
  }
}
