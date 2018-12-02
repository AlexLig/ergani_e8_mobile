import 'package:flutter/material.dart';

class CancelButtonMaxWidth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
          title: FlatButton(
        child: Text(
          'ΑΚΥΡΟ',
          style: TextStyle(color: Theme.of(context).buttonColor),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       child: Padding(
    //         padding: EdgeInsets.only(top: 2.0),
    //         child: FlatButton(
    //           child: Text(
    //             'ΑΚΥΡΟ',
    //             style: TextStyle(color: Theme.of(context).buttonColor),
    //           ),
    //           onPressed: () => Navigator.pop(context),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
