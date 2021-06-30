/// _id : ""
/// name : ""
/// price : ""
/// description : ""
/// photo : ""

class Variant {
  String? _id;
  String? _name;
  String? _price;
  String? _description;
  String? _photo;

  String? get id => _id;
  String? get name => _name;
  String? get price => _price;
  String? get description => _description;
  String? get photo => _photo;

  Variant(
      {String? id,
      String? name,
      String? price,
      String? description,
      String? photo}) {
    _id = id;
    _name = name;
    _price = price;
    _description = description;
    _photo = photo;
  }

  Variant.fromJson(dynamic json) {
    _id = json["_id"];
    _name = json["name"];
    _price = json["price"];
    _description = json["description"];
    _photo = json["photo"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["name"] = _name;
    map["price"] = _price;
    map["description"] = _description;
    map["photo"] = _photo;
    return map;
  }
}
