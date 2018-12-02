import 'package:flutter/material.dart';

class SubmitButtonMaxWidth extends StatelessWidget {
  final Function onSubmit;

  SubmitButtonMaxWidth({@required this.onSubmit}) : assert(onSubmit != null);
  @override
  Widget build(BuildContext context) {
    return ListTile(
          title: RaisedButton(
        onPressed: onSubmit,
        child: Text(
          'ΑΠΟΘΗΚΕΥΣΗ',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       child: Padding(
    //         padding: EdgeInsets.only(top: 30.0),
    //         child: RaisedButton(
    //           onPressed: onSubmit,
    //           child: Text(
    //             'ΑΠΟΘΗΚΕΥΣΗ',
    //             style: TextStyle(fontSize: 16.0, color: Colors.white),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
