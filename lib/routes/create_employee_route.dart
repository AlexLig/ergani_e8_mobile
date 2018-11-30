import 'package:ergani_e8/components/time_picker.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class CreateEmployeeRoute extends StatefulWidget {
  final Employee employee;
  CreateEmployeeRoute({BuildContext context, this.employee});

  @override
  CreateEmployeeRouteState createState() {
    return CreateEmployeeRouteState();
  }
}

// TODO: Don't add if AFM already exists.
class CreateEmployeeRouteState extends State<CreateEmployeeRoute> {
  final _formKey = GlobalKey<FormState>();
  // FocusNode employeeFocusNode;
  Employee _employee;
  TimeOfDay _workStart, _workFinish;

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _afmController = TextEditingController();

  var firstNameFocus = FocusNode();
  var lastNameFocus = FocusNode();
  var afmFocus = FocusNode();

  bool _shouldValidateOnChangeFirstName = false;
  bool _shouldValidateOnChangeLastName = false;
  bool _shouldValidateOnChangeAfm = false;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;

    _firstNameController.text = _employee?.firstName;
    _lastNameController.text = _employee?.lastName;
    _afmController.text = _employee?.afm;
    _workStart = _employee?.workStart ?? TimeOfDay(hour: 08, minute: 00);
    _workFinish = _employee?.workFinish ?? TimeOfDay(hour: 16, minute: 00);

    // firstNameFocus.addListener(() {
    //   if (!firstNameFocus.hasFocus) {
    //     setState(() => _shouldValidateOnChangeFirstName = true);
    //   }
    // });
    // lastNameFocus.addListener(() {
    //   if (!lastNameFocus.hasFocus)
    //     setState(() => _shouldValidateOnChangeLastName = true);
    // });
    // afmFocus.addListener(() {
    //   if (!afmFocus.hasFocus)
    //     setState(() => _shouldValidateOnChangeAfm = true);
    // });
  }

  @override
  void dispose() {
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    afmFocus.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _afmController.dispose();
    super.dispose();
  }

  void submit(context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      var firstName =
          //  _firstNameController.text[0].toUpperCase() +
          //         _firstNameController.text.substring(1) ??
          //     '';
          '${_firstNameController.text[0].toUpperCase()}${_firstNameController.text.substring(1)}';
      var lastName =
          //  _lastNameController.text[0].toUpperCase() +
          //         _lastNameController.text.substring(1) ??
          //     '';
          '${_lastNameController.text[0].toUpperCase()}${_lastNameController.text.substring(1)}';
      var afm = _afmController.text;

      var employeeToSubmit =
          Employee(firstName, lastName, afm, _workStart, _workFinish);

      _firstNameController.clear();
      _lastNameController.clear();
      _afmController.clear();
      Navigator.pop(context, employeeToSubmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${_employee == null ? 'Προσθήκη' : 'Επεξεργασία'} υπαλλήλου'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // FIRSTNAME Textfield
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: _buildFirstName(context),
                  )),

                  // LASTNAME textfield
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: _buildLastName(context),
                  )),
                ],
              ),
              // VATNUMBER textfield
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _buildVatNumber(context),
              ),
              // TIMETOSTART
              _buildWorkHours(context),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: RaisedButton(
                        onPressed: () => this.submit(context),
                        child: Text(
                          'ΑΠΟΘΗΚΕΥΣΗ',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: FlatButton(
                        // shape: OutlineInputBorder(
                        //   borderSide:
                        //       BorderSide(color: Theme.of(context).buttonColor),
                        // ),
                        child: Text(
                          'ΑΚΥΡΟ',
                          style:
                              TextStyle(color: Theme.of(context).buttonColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildFirstName(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(lastNameFocus);
      },
      autofocus: true,
      autovalidate: _shouldValidateOnChangeFirstName,
      focusNode: firstNameFocus,
      decoration: InputDecoration(
        labelText: 'Όνομα',
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor)),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Προσθέστε όνομα';
        }
      },
      controller: _firstNameController,
    );
  }

  TextFormField _buildLastName(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (value.isEmpty)
          setState(() => _shouldValidateOnChangeLastName = true);
        else
          FocusScope.of(context).requestFocus(afmFocus);
      },
      focusNode: lastNameFocus,
      decoration: InputDecoration(
        labelText: 'Επίθετο',
        border: OutlineInputBorder(),
        // prefixIcon: Icon(Icons.perm_contact_calendar)
        // prefixIcon: Icon(Icons.recent_actors)
        prefixIcon: Icon(Icons.contacts),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Προσθέστε επίθετο';
      },
      autovalidate: _shouldValidateOnChangeLastName,
      // onEditingComplete: () =>
      controller: _lastNameController,
    );
  }

  TextFormField _buildVatNumber(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      focusNode: afmFocus,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'ΑΦΜ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.work),
      ),
      // validator: (value) => validateAfm(value),
      autovalidate: _shouldValidateOnChangeAfm,
      maxLength: 9,
      onFieldSubmitted: (value) {
        // if (isNotNumeric(value) || value.length != 9)
        setState(() => _shouldValidateOnChangeAfm = true);
        // else
        // FocusScope.of(context).requestFocus();
      },
      controller: _afmController,
    );
  }

  _buildWorkHours(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TimePickerButton(
          workHour: _workStart,
          onPressed: () => _selectWorkStart(context),
        ),
        Icon(Icons.arrow_forward),
        TimePickerButton(
          workHour: _workFinish,
          onPressed: () => _selectWorkFinish(context),
        ),
      ],
    );
  }

  void _selectWorkStart(BuildContext context) async {
    final TimeOfDay startTime = await showTimePicker(
      context: context,
      initialTime: _workStart,
    );

    if (startTime is TimeOfDay) setState(() => _workStart = startTime);
  }

  void _selectWorkFinish(BuildContext context) async {
    final TimeOfDay finishTime = await showTimePicker(
      context: context,
      initialTime: _workFinish,
    );

    if (finishTime is TimeOfDay) setState(() => _workFinish = finishTime);
  }
}
