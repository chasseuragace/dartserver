/// _id : ""
/// items : ["df"]
/// coupon : "df"

class Cart {
  String? _id;
  List<String>? _items;
  String? _coupon;

  String? get id => _id;
  List<String>? get items => _items;
  String? get coupon => _coupon;

  Cart({String? id, List<String>? items, String? coupon}) {
    _id = id;
    _items = items;
    _coupon = coupon;
  }

  Cart.fromJson(dynamic json) {
    _id = json["_id"];
    _items = json["items"] != null ? json["items"].cast<String>() : [];
    _coupon = json["coupon"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["items"] = _items;
    map["coupon"] = _coupon;
    return map;
  }
}
