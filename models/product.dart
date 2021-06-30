/// _id : ""
/// name : ""
/// price : ""
/// variant : ["sd"]
/// description : ""
/// photo : ""
/// category : ["sd"]

class Product {
  String? _id;
  String? _name;
  String? _price;
  List<String>? _variant;
  String? _description;
  String? _photo;
  List<String>? _category;

  String? get id => _id;
  String? get name => _name;
  String? get price => _price;
  List<String>? get variant => _variant;
  String? get description => _description;
  String? get photo => _photo;
  List<String>? get category => _category;

  Product(
      {String? id,
      String? name,
      String? price,
      List<String>? variant,
      String? description,
      String? photo,
      List<String>? category}) {
    _id = id;
    _name = name;
    _price = price;
    _variant = variant;
    _description = description;
    _photo = photo;
    _category = category;
  }

  Product.fromJson(dynamic json) {
    _id = json["_id"];
    _name = json["name"];
    _price = json["price"];
    _variant = json["variant"] != null ? json["variant"].cast<String>() : [];
    _description = json["description"];
    _photo = json["photo"];
    _category = json["category"] != null ? json["category"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["name"] = _name;
    map["price"] = _price;
    map["variant"] = _variant;
    map["description"] = _description;
    map["photo"] = _photo;
    map["category"] = _category;
    return map;
  }
}
