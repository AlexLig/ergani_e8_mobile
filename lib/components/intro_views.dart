import 'package:ergani_e8/routes/new_employer_route.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

// pageColor: Color(0xff666c83)
// pageColor: Color(0xff4b5a6a)
// pageColor: Color(0xff37474f)

class IntroViews extends StatelessWidget {
  final pages = [
    PageViewModel(
      pageColor: Color(0xff366275),
      // pageColor: Color(0xff3b7f89),
      // pageColor: Color(0xff586971),
      bubble: Icon(Icons.save, color: Colors.white),
      body: Text('Τα στοιχεία που εισάγετε διαμορφώνουν το έντυπο Ε8.', style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center,),
      title: Text('Εταιρικό προφίλ', style: TextStyle(fontSize: 30.0),),
      mainImage: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.account_box),
        ],
      ),

      // textStyle: TextStyle(fontFamily: 'roboto', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color(0xffcc7f2a),

      bubble: Icon(Icons.person_add, color: Colors.white),
      body: Text('Τα δεδομένα αποθηκεύονται αποκλειστικά στη συσκεή.', style: TextStyle(fontSize: 20.0),),
      title: Text('Συλλογή υπαλλήλων', style: TextStyle(fontSize: 30.0),),
      mainImage: Icon(Icons.account_box),
      // textStyle: TextStyle(fontSize: 14.0),
    ),
    PageViewModel(
      // pageColor: Color(0xff523f50),
      pageColor: Colors.green,

      bubble: Icon(Icons.send, color: Colors.white),
      body: Text('Επιλέξτε τον χρόνο υπερωρίας και στείλτε άμεσα το έντυπο Ε8 με SMS.', style: TextStyle(fontSize: 20.0),),
      title: Text('Αποστολή μηνύματος', style: TextStyle(fontSize: 30.0),),
      mainImage: Icon(Icons.account_box),
      // textStyle: TextStyle(fontSize: 14.0),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNewEmployer()),
            );
          },
          pageButtonTextStyles: TextStyle(
            // color: Colors.white,
            // fontSize: 14.0,
          ),
          skipText: Text('ΠΑΡΑΛΕΙΨΗ', style: TextStyle(fontSize: 14.0)),
          doneText: Text('ΕΓΙΝΕ'),
        );
      },
    );
  }
}
