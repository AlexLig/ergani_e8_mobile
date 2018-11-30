import 'package:ergani_e8/e8/e8form.dart';
import 'package:flutter/material.dart';

class E8home extends StatefulWidget {
  @override
  E8homeState createState() => E8homeState();
}

class E8homeState extends State<E8home> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Φορμα Ε8'),
        bottom: TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(text: 'ΝΕΑ ΥΠΟΒΟΛΗ'),
            Tab(text: 'ΑΚΥΡΩΣΗ ΥΠΟΒΟΛΗΣ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          E8form(isReset: false),
          E8form(isReset: true),
        ],
      ),
    );
  }
}
