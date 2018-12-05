import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  final String par1 =
      'Η παρούσα εφαρμογή έχει αναπτυχθεί ως εργαλείο για τη διευκόλυνση αποστολής του εντύπου Ε8 με SMS και δεν παρουσιάζεται ως πηγή ενημέρωσης για το σύστημα Εργάνη.';
  final String par2 =
      'Η χρήση της εφαρμογής γίνεται χωρίς πρόσβαση στο διαδίκτυο και οι πληροφορίες που καταχωρούνται αποθηκεύονται αποκλειστικά στη συσκευή.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Αποποίηση Ευθύνης')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 14.0),
              children: <Widget>[
                ListTile(
                  title: Text(
                    par1,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                ListTile(
                  title: Text(
                    par2,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
