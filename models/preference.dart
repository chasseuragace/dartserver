/// _id : ""
/// name : ""
/// idea : ["df"]

class Preference {
  String? _id;
  String? _name;
  List<String>? _idea;

  String? get id => _id;
  String? get name => _name;
  List<String>? get idea => _idea;

  Preference({String? id, String? name, List<String>? idea}) {
    _id = id;
    _name = name;
    _idea = idea;
  }

  Preference.fromJson(dynamic json) {
    _id = json["_id"];
    _name = json["name"];
    _idea = json["idea"] != null ? json["idea"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["name"] = _name;
    map["idea"] = _idea;
    return map;
  }
}
