import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String text;

  const InfoTile({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: ListTile(
        title: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColorLight),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              selected: true,
              leading: Icon(Icons.info_outline),
              subtitle: Text(text, textAlign: TextAlign.center),
              // contentPadding: EdgeInsets.symmetric(horizontal: 40.0),
            ),
          ),
        ),
      ),
    );
  }
}
