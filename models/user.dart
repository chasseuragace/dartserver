/// _id : ""
/// name : ""
/// email : ""
/// password : ""
/// photo : ""
/// address : ["we"]
/// cart : ""
/// wishlist : ""
/// preference : ["we"]
/// orders : ["we"]

class User {
  String? _id;
  String? _name;
  String? _email;
  String? _password;
  String? _photo;
  List<String>? _address;
  String? _cart;
  String? _wishlist;
  List<String>? _preference;
  List<String>? _orders;

  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  String? get photo => _photo;
  List<String>? get address => _address;
  String? get cart => _cart;
  String? get wishlist => _wishlist;
  List<String>? get preference => _preference;
  List<String>? get orders => _orders;

  User(
      {String? id,
      String? name,
      String? email,
      String? password,
      String? photo,
      List<String>? address,
      String? cart,
      String? wishlist,
      List<String>? preference,
      List<String>? orders}) {
    _id = id;
    _name = name;
    _email = email;
    _password = password;
    _photo = photo;
    _address = address;
    _cart = cart;
    _wishlist = wishlist;
    _preference = preference;
    _orders = orders;
  }

  User.fromJson(dynamic json) {
    _id = json["_id"];
    _name = json["name"];
    _email = json["email"];
    _password = json["password"];
    _photo = json["photo"];
    _address = json["address"] != null ? json["address"].cast<String>() : [];
    _cart = json["cart"];
    _wishlist = json["wishlist"];
    _preference =
        json["preference"] != null ? json["preference"].cast<String>() : [];
    _orders = json["orders"] != null ? json["orders"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["password"] = _password;
    map["photo"] = _photo;
    map["address"] = _address;
    map["cart"] = _cart;
    map["wishlist"] = _wishlist;
    map["preference"] = _preference;
    map["orders"] = _orders;
    map.removeWhere((key, value) => value == null);
    return map;
  }

  Map<String, dynamic> toJsonSecure() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["photo"] = _photo;
    map["address"] = _address;
    map["cart"] = _cart;
    map["wishlist"] = _wishlist;
    map["orders"] = _orders;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
