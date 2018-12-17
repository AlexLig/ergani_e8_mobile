import 'package:flutter/material.dart';

class MessageBottomSheet extends StatelessWidget {
  final Function onSend;
  final TextEditingController smsNumberController, senderController;
  final String message;
  final bool isLoading;

  MessageBottomSheet({
    Key key,
    this.senderController,
    this.smsNumberController,
    this.message,
    this.onSend,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Text('ΑΠΟ'),
              title: TextField(
                enabled: false,
                controller: senderController,
              ),
            ),
            ListTile(
              leading: Text('ΠΡΟΣ'),
              title: TextField(
                enabled: false,
                controller: smsNumberController,
              ),
            ),
            ListTile(
              title: Text(message),
              leading: Icon(Icons.chat),
            ),
            ListTile(
              trailing: RaisedButton(
                onPressed: isLoading ? null : onSend,
                disabledColor: Theme.of(context).primaryColorLight,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ΑΠΟΣΤΟΛΗ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    isLoading
                        ? Container(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          )
                        : null,
                  ].where((val) => val != null).toList(),
                ),
              ),
            ),
            onSend == null
                ? ListTile(
                    leading: Icon(Icons.warning, color: Colors.deepOrange),
                    title: Text(
                      'Η δήλωση υπερωρίας γίνεται μόνο πριν την έναρξή της.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  )
                : null,
          ].where((val) => val != null).toList(),
        ),
      ),
    );
  }
}
