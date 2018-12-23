import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';
import 'employee_list_tile.dart';

class EmployerListTile extends StatelessWidget {
  final Function onTap;
  final Employer employer;

  EmployerListTile({
    Key key,
    @required this.employer,
    this.onTap,
  }) : super(key: key);

  String _getInitials() {
    final words = employer.name.split(' ');
    return words.length > 1
        ? normalize(words[0][0]) + normalize(words[1][0])
        : normalize(words[0][0]);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              '${_getInitials()}',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          '${employer.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        subtitle: Column(
          children: <Widget>[
            Text(
              'ΑΦΜ: ${employer.afm}',
              style: TextStyle(color: Colors.white),
            ),
            employer.ame != null
                ? Text(
                    'ΑΜΕ: ${employer.ame}',
                    style: TextStyle(color: Colors.white),
                  )
                : null
          ].where((val) => val != null).toList(),
        ),
        isThreeLine: employer.ame != null,
        trailing: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
      ),
    );
  }
}
