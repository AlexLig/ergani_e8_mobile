import 'package:ergani_e8/components/drawer_info_routes/contact.dart';
import 'package:ergani_e8/components/drawer_info_routes/disclaimer.dart';
import 'package:ergani_e8/components/drawer_info_routes/e8Instructions.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/settings_route.dart';
import 'package:flutter/material.dart';

class ContactsDrawer extends StatelessWidget {
  final Employer employer;
  ContactsDrawer({Key key, this.employer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          // padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      employer.name ?? 'Όνομα Εταιρείας',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'ΑΦΜ: ${employer.afm ?? ''} ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      employer.ame != null && employer.ame.isNotEmpty
                          ? 'ΑΜΕ: ${employer.ame}'
                          : '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateEmployer(
                          employer: employer,
                        ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Ρυθμίσεις'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => E8Instructions(),
                  ),
                );
              },
              child: ListTile(
                title: Text('Οδηγίες Συμπλήρωσης Ε8'),
                leading: Icon(
                  Icons.info_outline,
                  // color: Colors.grey[600],
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: ListTile(title: Text('Αποποίηση Ευθύνης')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Disclaimer(),
                  ),
                );
              },
            ),
            InkWell(
              child: ListTile(title: Text('Επικοινωνία')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Contact(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
