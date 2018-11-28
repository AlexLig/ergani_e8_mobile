class Employer {
  String _name;
  int _id, _afm, _ame;

  Employer(this._afm, [this._name, this._ame]);

  Employer.withID(this._id, this._afm, [this._name, this._ame]);

  Employer.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._afm = map['afm'];
    this._ame = map['ame'];
  }

  String get name => this._name;
  int get afm => this._afm;
  int get ame => this._ame;
  int get id => this._id;

  set name(String name) {
    name.isNotEmpty ? this._name = name.trim() : this._name = 'Εργοδότης';
  }

  set afm(int afm) {
    if (afm == 9) this._afm = afm;
  }

  set ame(int ame) {
    if (ame == 9) this._ame = ame;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = this._id;
    map['name'] = this._name; // this.name ?
    map['afm'] = this._afm;
    map['ame'] = this._ame; // this.AME?

    return map;
  }

  bool hasAme() => this._ame == null ? true : false;
}
