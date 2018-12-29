import 'package:ergani_e8/employerForm/validator_bloc.dart';
import 'package:rxdart/rxdart.dart';

class EmployerBloc extends Object with ValidatorBloc {
  final _nameController = BehaviorSubject<String>();
  final _afmController = BehaviorSubject<String>();
  final _hasAmeController = BehaviorSubject<bool>();
  final _smsReceiverController = BehaviorSubject<String>();

  //Get data from the stream
  Stream<bool> get hasAmeStream => _hasAmeController.stream;
  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get afmStream =>
      _afmController.stream.transform(validateNumeric);
  Stream<String> get smsReceiverStream =>
      _smsReceiverController.stream.transform(validateNumeric);

  Stream<bool> get shouldSubmit => Observable.combineLatest3(
      nameStream, afmStream, smsReceiverStream, (name, afm, sms) => true);

  // Stream input
  Function(String) get updateName => _nameController.sink.add;
  Function(String) get updateAfm => _afmController.sink.add;
  Function(String) get updateSmsReceiver => _smsReceiverController.sink.add;
  Function(bool) get updateHasAme => _hasAmeController.sink.add;
  //TODO: add ame controller and  update.
  dispose() {
    _nameController.close();
    _afmController.close();
    _hasAmeController.close();
    _smsReceiverController.close();
  }
}
