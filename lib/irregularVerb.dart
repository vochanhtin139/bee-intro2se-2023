class irregularVerb {
  int? id;
  String? v1, v2, v3;

  irregularVerb();

  irregularVerb.map(dynamic obj) {
    this.id = obj['_id'];
    this.v1 = obj['v1'];
    this.v2 = obj['v2'];
    this.v3 = obj['v3'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['_id'] = this.id;
    map['v1'] = this.v1;
    map['v2'] = this.v2;
    map['v3'] = this.v3;

    return map;
  }
}