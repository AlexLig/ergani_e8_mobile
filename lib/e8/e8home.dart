import 'package:ergani_e8/e8/e8form.dart';
import 'package:flutter/material.dart';

class E8home extends StatefulWidget {
  @override
  E8homeState createState() => E8homeState();
}

class E8homeState extends State<E8home> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Φορμα Ε8'),
      ),
      body: E8form(),
    );
  }
}
