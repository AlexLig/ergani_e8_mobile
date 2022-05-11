class Employer {
  String _name, _afm, _ame, _smsNumber;
  int _id;

  Employer(this._afm, this._name, this._smsNumber, [this._ame = '']);

  Employer.withID(this._id, this._afm, this._name, this._smsNumber,
      [this._ame = '']);
//
  Employer.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._afm = map['afm'];
    this._ame = map['ame'] ?? '';
    this._smsNumber = map['sms_number'];
  }

  String get name => this._name;
  String get afm => this._afm ?? '';
  String get ame => this._ame;
  String get smsNumber => this._smsNumber;
  int get id => this._id;
  bool get hasAme => this.ame.isNotEmpty;

  set name(String name) => this._name = name.trim();

  set afm(String afm) => this._afm = afm;

  set ame(String ame) => this._ame = ame;

  set smsNumber(String smsNumber) => this._smsNumber = smsNumber;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = this._id;
    map['name'] = this._name; // this.name ?
    map['afm'] = this._afm;
    map['ame'] = this._ame; // this.AME?
    map['sms_number'] = this._smsNumber; // this.AME?

    return map;
  }
}
