class Employer {
  String _name, _afm, _ame;
  int _id;

  Employer(this._afm, [this._name, this._ame]);

  Employer.withID(this._id, this._afm, [this._name, this._ame]);

  Employer.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._afm = map['afm'];
    this._ame = map['ame'];
  }

  String get name => this._name;
  String get afm => this._afm;
  String get ame => this._ame;
  int get id => this._id;

  set name(String name) {
    this._name = name.trim();
  }

  set afm(String afm) {
    if (afm.length == 9) this._afm = afm;
  }

  set ame(String ame) {
    if (ame.length == 9) this._ame = ame;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = this._id;
    map['name'] = this._name; // this.name ?
    map['afm'] = this._afm;
    map['ame'] = this._ame; // this.AME?

    return map;
  }

}
