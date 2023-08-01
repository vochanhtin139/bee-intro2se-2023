class wordMeaning {
  int? id;
  String? word, html, description, pronounce;

  wordMeaning();

  wordMeaning.map(dynamic obj) {
    this.id = obj['_id'];
    this.word = obj['word'];
    this.html = obj['html'];
    this.description = obj['description'];
    this.pronounce = obj['pronounce'];
  }

  wordMeaning.mapHistory(dynamic obj) {
    this.id = 0;
    this.word = obj['_word'];
    this.html = '';
    this.description = '';
    this.pronounce = '';
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['_id'] = this.id;
    map['word'] = this.word;
    map['html'] = this.html;
    map['description'] = this.description;
    map['pronounce'] = this.pronounce;

    return map;
  }
}