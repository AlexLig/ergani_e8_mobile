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
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Theme.of(context).primaryColorDark,
                //     Theme.of(context).primaryColor,
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                color: Theme.of(context).primaryColor,
              ),
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
                leading: Icon(Icons.business),
                title: Text('Εταιρικό Προφίλ'),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: ListTile(title: Text('Οδηγίες συμπλήρωσης Ε8')),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: ListTile(title: Text('About Us')),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: ListTile(title: Text('Disclaimer')),
            ),
          ],
        ),
      ),
    );
  }
}
