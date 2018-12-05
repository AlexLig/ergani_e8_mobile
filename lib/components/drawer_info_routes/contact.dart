import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Επικοινωνία'),
        ),
        body: Builder(builder: (context) {
          this.scaffoldContext = context;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                        title: Text('Επικοινωνήστε με τους προγραμματιστές:')),
                    InkWell(
                      onTap: () =>
                          _sendMail(scaffoldContext, 'ligkalex@gmail.com'),
                      child: ListTile(
                          title: Text('Λίγκας Αλέξανδρος'),
                          subtitle: Text('ligkalex@gmail.com')),
                    ),
                    InkWell(
                      onTap: () =>
                          _sendMail(scaffoldContext, 'libekonst@gmail.com'),
                      child: ListTile(
                          title: Text('Λυμπερόπουλος Κωσταντίνος'),
                          subtitle: Text('libekonst@gmail.com')),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  _sendMail(BuildContext context, String address) async {
    final email = 'mailto:$address?subject=Σχετικά%20με%20την%20εφαρμογή%20Ε8';
    if (await canLaunch(email))
      await launch(email);
    else
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Αδυναμία αποστολής email.'),
      ));
  }
}
