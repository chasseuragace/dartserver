/// _id : ""
/// items : ["dfdf"]

class Wishlist {
  String? _id;
  List<String>? _items;

  String? get id => _id;
  List<String>? get items => _items;

  Wishlist({String? id, List<String>? items}) {
    _id = id;
    _items = items;
  }

  Wishlist.fromJson(dynamic json) {
    _id = json["_id"];
    _items = json["items"] != null ? json["items"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["items"] = _items;
    return map;
  }
}
