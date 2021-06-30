/// _id : ""
/// city : ""
/// street : ""
/// detail : ""
/// isDefault : false
/// phone : ""

class Address {
  static final NAME = "ADDRESS";
  String? _id;
  String? _city;
  String? _street;
  String? _detail;
  bool? _isDefault;
  String? _phone;

  String? get id => _id;
  String? get city => _city;
  String? get street => _street;
  String? get detail => _detail;
  bool? get isDefault => _isDefault;
  String? get phone => _phone;

  Address(
      {String? id,
      String? city,
      String? street,
      String? detail,
      bool? isDefault,
      String? phone}) {
    _id = id;
    _city = city;
    _street = street;
    _detail = detail;
    _isDefault = isDefault;
    _phone = phone;
  }

  Address.fromJson(dynamic json) {
    _id = json["_id"];
    _city = json["city"];
    _street = json["street"];
    _detail = json["detail"];
    _isDefault = json["isDefault"];
    _phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["city"] = _city;
    map["street"] = _street;
    map["detail"] = _detail;
    map["isDefault"] = _isDefault;
    map["phone"] = _phone;
    return map;
  }
}
