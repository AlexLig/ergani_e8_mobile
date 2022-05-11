import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  final String string;
  final bool heavy;

  WhiteText(this.string, {this.heavy});

  @override
  Widget build(BuildContext context) {
    return Text(
      string,
      style: this.heavy
          ? TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)
          : TextStyle(color: Colors.white),
    );
  }
}
