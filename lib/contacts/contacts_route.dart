import 'package:ergani_e8/contacts/drawer.dart';
import 'package:flutter/material.dart';

class ContactsRoute extends StatefulWidget {
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class ContactsRouteState extends State<ContactsRoute> {
  int _counter = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _incrementCounter() => setState(() => _counter++);
  void _resetCounter() => setState(() => _counter = 0);
  _showSnackBar(context) => () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Trying to search? o.O'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            textColor: Colors.white,
            label: 'Not really',
            onPressed: () => print('Trolled.'),
          ),
        ));
      };

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Υπάλληλοι'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Αναζήτηση',
            // SnackBar not working here. Need GlobalKey??
            onPressed: _showSnackBar(context),
          )
        ],
      ),
      // Needed to open a snackbar.
      // This happens because you are using the context of the widget that instantiated Scaffold.
      // Not the context of a child of Scaffold.
      // You can solve this by simply using a different context :
      body: Builder(builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pressed the button this many times $_counter'),
              FlatButton(child: Text('Reset'), onPressed: _resetCounter),
              FlatButton.icon(
                icon: Icon(Icons.search),
                label: Text('Search'),
                onPressed: _showSnackBar(context),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: _incrementCounter,
      ),
      drawer: ContactsDrawer(),
    );
  }
}
