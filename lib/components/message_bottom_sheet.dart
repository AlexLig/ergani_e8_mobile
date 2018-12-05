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
    return PhysicalModel(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.white,
      elevation: 7.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Text('ΑΠΟ'),
              title: TextField(
                enabled: false,
                controller: senderController,
                // decoration: InputDecoration(prefixText: 'ΑΠΟ      '),
              ),
            ),
            ListTile(
              leading: Text('ΠΡΟΣ'),
              title: TextField(
                enabled: false,
                controller: smsNumberController,
                // decoration: InputDecoration(prefixText: 'ΠΡΟΣ    '),
              ),
            ),
            ListTile(
              title: Text(message),
              leading: Icon(Icons.message),
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
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          )
                        : null,
                  ].where((val) => val != null).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
