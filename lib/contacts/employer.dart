import 'package:meta/meta.dart';

class Employer {
  final String name, vatNumberAFM, vatNumberAME;

  const Employer({
    this.name,
    this.vatNumberAME,
    @required this.vatNumberAFM,
  }) : assert(vatNumberAFM != null);

  
}
