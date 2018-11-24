import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/employer_list_tile.dart';
import 'package:ergani_e8/components/sliderTimePicker.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:flutter/material.dart';

class E8form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.textsms),
        onPressed: () => print('hi'),
      ),
      body: Builder(
        builder: (context) => Column(
              children: <Widget>[
                EmployerListTile(employer: E8provider.of(context).employer),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          EmployeeListTile(
                              employee: E8provider.of(context).employee),
                          Divider(),
                          SliderTimePicker(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
      ),
    );
  }
}
