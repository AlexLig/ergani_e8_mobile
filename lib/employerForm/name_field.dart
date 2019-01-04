import 'package:ergani_e8/employerForm/employer_bloc_provider.dart';
import 'package:flutter/material.dart';

class NameField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NameFieldState();
}

class NameFieldState extends State<NameField> {
  @override
  Widget build(BuildContext context) {
    var employerBloc = EmployerBlocProvider.of(context);
    return StreamBuilder(
      initialData: 'hi',
      stream: employerBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListTile(
          title: TextField(
            onChanged: employerBloc.updateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Όνομα Εργοδότη',
                prefixIcon: Icon(Icons.person),
                errorText: snapshot.error),
          ),
        );
      },
    );
  }
}
