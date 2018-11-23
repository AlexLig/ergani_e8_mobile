import 'package:ergani_e8/vatNumbers.dart';
import 'package:flutter/material.dart';
import 'package:ergani_e8/e8formCreate.dart';

class E8formCancel extends StatefulWidget {
  final VatNumbers vatNumbers;
  final TimeOfDay commonFinishHour;
  E8formCancel({Key key, @required this.vatNumbers, this.commonFinishHour})
      : super(key: key);

  @override
  E8formState createState() => E8formState();
}

class E8formState extends State<E8formCancel> {
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;

  Widget _buildEmployee(BuildContext context) => ListTile(
        title: Text('Κωστας Γουστουριδης'),
        subtitle: Text('ΑΦΜ: ${widget.vatNumbers.afmEmployer}'),
      );
  Widget _buildEmployer(BuildContext context) => ListTile(
        title: Text('AGFA Αθήνα'),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text('ΑΦΜ: ${widget.vatNumbers.afmEmployer}'),
            ),
            _child
          ],
        ),
      );
  Widget _child;
  Widget _buildOverTimePicker(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Ώρες υπερεργασίας',
          style: TextStyle(fontSize: 18.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              // TODO : set context to alwaysUse24HourFormat
              child: Text(_overtimeStart.format(context)),
              onPressed: () {},
            ),
            Icon(Icons.arrow_forward),
            FlatButton(
              child: Text(_overtimeFinish.format(context)),
              onPressed: () {},
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Slider(
            divisions: 5,
            min: 0.5,
            max: 3.0,
            value: _sliderValue,
            onChanged: (newSliderValue) {
              return null;
            },
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    _sliderValue = 0.5;
    _overtimeStart = TimeOfDay(hour: 00, minute: 00);
    _overtimeFinish = TimeOfDay(hour: 00, minute: 00);
    _child = widget.vatNumbers.ameEmployer != null
        ? Text('ΑΜΕ: ${widget.vatNumbers.ameEmployer}')
        : Container();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () => print('hi'),
        backgroundColor: Colors.red,
      ),
      appBar: AppBar(title: Text('Ακύρωση προηγούμενης υποβολής'),),
      body: Builder(
        builder: (context) => Column(
              children: <Widget>[
                _buildEmployer(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          _buildEmployee(context),
                          Divider(),
                          _buildOverTimePicker(context),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
      ),
    );
  }
}
