/// _id : ""
/// name : "sd"
/// email : "Sd"
/// password : "sd"
/// products : ["sd"]
/// sales : ["sd"]
/// ads : ["sd"]
/// logo : "sd"
/// banners : ["sd"]
/// slogan : "sd"
/// address : ["sdsd"]

class Shop {
  String? _id;
  String? _name;
  String? _email;
  String? _password;
  List<String>? _products;
  List<String>? _sales;
  List<String>? _ads;
  String? _logo;
  List<String>? _banners;
  String? _slogan;
  List<String>? _address;

  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  List<String>? get products => _products;
  List<String>? get sales => _sales;
  List<String>? get ads => _ads;
  String? get logo => _logo;
  List<String>? get banners => _banners;
  String? get slogan => _slogan;
  List<String>? get address => _address;

  Shop(
      {String? id,
      String? name,
      String? email,
      String? password,
      List<String>? products,
      List<String>? sales,
      List<String>? ads,
      String? logo,
      List<String>? banners,
      String? slogan,
      List<String>? address}) {
    _id = id;
    _name = name;
    _email = email;
    _password = password;
    _products = products;
    _sales = sales;
    _ads = ads;
    _logo = logo;
    _banners = banners;
    _slogan = slogan;
    _address = address;
  }

  Shop.fromJson(dynamic json) {
    _id = json["_id"];
    _name = json["name"];
    _email = json["email"];
    _password = json["password"];
    _products = json["products"] != null ? json["products"].cast<String>() : [];
    _sales = json["sales"] != null ? json["sales"].cast<String>() : [];
    _ads = json["ads"] != null ? json["ads"].cast<String>() : [];
    _logo = json["logo"];
    _banners = json["banners"] != null ? json["banners"].cast<String>() : [];
    _slogan = json["slogan"];
    _address = json["address"] != null ? json["address"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["password"] = _password;
    map["products"] = _products;
    map["sales"] = _sales;
    map["ads"] = _ads;
    map["logo"] = _logo;
    map["banners"] = _banners;
    map["slogan"] = _slogan;
    map["address"] = _address;
    return map;
  }
}
