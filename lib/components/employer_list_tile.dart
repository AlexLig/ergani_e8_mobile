import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class EmployerListTile extends StatelessWidget{
  final Employer employer;

  EmployerListTile({this.employer});

  @override
  Widget build(BuildContext context) {
    
    return  ListTile(
        title:
            Text('${isNotNull(employer.name) ? employer.name : 'Εργοδότης'}'),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text('ΑΦΜ: ${employer.vatNumberAFM}'),
            ),
            isNotNull(employer.vatNumberAME)
                ? Text('ΑΜΕ: ${employer.vatNumberAME}')
                : null,
          ].where(notNull).toList(),
        ),
      );
  }

}
