import 'package:flutter/material.dart';

class ContactsDrawer extends StatelessWidget {
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
                      'Όνομα Εταιρείας',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'ΑΦΜ Εταιρείας',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildDrawerTile(
            onTap: () => Navigator.pop(context),
            icon: Icon(Icons.settings),
            title: 'Ρυθμίσεις',
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
