import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/create_employer_route.dart';
import 'package:flutter/material.dart';

class ContactsDrawer extends StatelessWidget {
  final Employer employer;
  ContactsDrawer({Key key, this.employer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.zero,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
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
                      employer.ame != null && employer.ame.isNotEmpty ? 'ΑΜΕ: ${employer.ame}' : '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildDrawerTile(
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployerForm(
                          employer: employer,
                        )),
              );
            },
            icon: Icon(Icons.business),
            title: 'Εταιρικό Προφίλ',
          ),
          Divider(),
          _buildDrawerTile(
            onTap: () => Navigator.pop(context),
            title: 'Οδηγίες συμπλήρωσης Ε8',
          ),
          _buildDrawerTile(
            onTap: () => Navigator.pop(context),
            title: 'Disclaimer',
          ),
          _buildDrawerTile(
            onTap: () => Navigator.pop(context),
            title: 'About us',
          ),
        ],
      ),
    );
  }

  _buildDrawerTile({
    @required Function onTap,
    @required String title,
    Icon icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        leading: icon,
      ),
    );
  }
}
