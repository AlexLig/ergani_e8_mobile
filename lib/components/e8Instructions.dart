import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class E8Instructions extends StatelessWidget {
  final String requirementsTitle =
      'Το έντυπο νέο-Ε8 υποβάλλεται με αποστολή γραπτού μηνύματος (SMS) στον αριθμό 54001 με τις ακόλουθες προϋποθέσεις:';
  final String requirementOne =
      'Για τον απασχολούμενο, για τον οποίο πρόκειται να υποβληθεί SMS, να έχει πραγματοποιηθεί στο παρελθόν τουλάχιστον μια υποβολή νέου-Ε8 με κάποιον από τους υπόλοιπους τρόπους υποβολής';
  final String requirementTwo =
      'Να έχει καταχωρηθεί στο ΠΣ ΕΡΓΑΝΗ και να είναι σε ισχύ ο αριθμός του κινητού τηλεφώνου από το μενού [Αριθμοί Κινητών Τηλεφώνων]';
  final String requirementThree =
      'Ο εργαζόμενος να είναι στην τρέχουσα κατάσταση (μενού [Μητρώα] - [Στοιχεία Προσωπικού] και επιλογή πεδίου [Τρέχουσα Κατάσταση]).';
  final String infoParagraphOne =
      'Το γραπτό μήνυμα αναφέρεται στο χρονικό διάστημα των 24 ωρών που ακολουθεί την υποβολή.Καταχώρηση αριθμών κινητών τηλεφώνων ';
  final String infoParagraphTwo =
      'Απαραίτητη προϋπόθεση για την υποβολή νέου-Ε8 με γραπτό μήνυμα (SMS) είναι να έχουν καταχωρηθεί και να είναι ενεργοί στο ΠΣ ΕΡΓΑΝΗ οι αριθμοί των κινητών τηλεφώνων, από τα οποία πρόκειται να πραγματοποιηθούν υποβολές. Καταχωρώντας τιμές στα πεδία [Ημερομηνία Από] και [Ημερομηνία Έως], ο χρήστης επιλέγει για ποιο χρονικό διάστημα θα είναι ενεργός ο κάθε τηλεφωνικός αριθμός.';
  final String infoParagraphThree =
      'Δεν υπάρχει δυνατότητα διαγραφής των εισαχθέντων τηλεφωνικών αριθμών, παρά μόνο απενεργοποίησης τους, επιλέγοντας τιμές για τα πεδία [Ημερομηνία Από] και [Ημερομηνία Έως] προγενέστερες από την τρέχουσα ημερομηνία.';
  final String infoSourceLabel = 'Πηγή: Taxheaven © ';
  final String infoSourceUrl =
      'https://www.taxheaven.gr/news/news/view/id/41669';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Πληροφορίες για το έντυπο Ε8'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4, 24, 4, 4),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: _buildTextList()),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextList() {
    final List<String> list = [
      requirementsTitle,
      requirementOne,
      requirementTwo,
      requirementThree,
      infoParagraphOne,
      infoParagraphTwo,
      infoParagraphThree
    ];
    List<Widget> instructionList = list.map((item) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(item,softWrap: true,),
      );
    }).toList();
    instructionList.add(_buildSourceLink());
    return instructionList;
  }

  Widget _buildSourceLink() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: infoSourceLabel,
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Δείτε περισσότερα',
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(infoSourceUrl);
                },
            ),
          ],
        ),
      ),
    );
  }
}
