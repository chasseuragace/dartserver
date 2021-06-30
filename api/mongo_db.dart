import 'package:mongo_dart/mongo_dart.dart';

import '../models/user.dart';

class Database {
  late final Db _db;
  init() async {
    _db = await Db.create(
        "mongodb+srv://chasseuragaceDB1:Hj028j7dvwmUruJH@cluster0.guoul.mongodb.net/myFirstDatabase?retryWrites=true");
    await _db.open();

    print("connected to database");
  }
}

late Database database;

class Collection {
  static Map<String, DbCollection> collections = {};

  Future<Map<String, dynamic>?> save(dynamic data,
      {Map<String, dynamic>? check}) async {
    String collectionName = data.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    if (check != null) {
      var alreadyExists = await collections[collectionName]?.findOne(check);
      print("$alreadyExists");
      if (alreadyExists != null) return {"error": "User Already Exists"};
    }
    var baka = await collections[collectionName]?.insertOne(data.toJson());
    return ((baka?.document));
  }

  update(Map<String, dynamic> old, dynamic data) async {
    var update = data.toJson() as Map<String, dynamic>;
    var oldSaved = Map<String, dynamic>.from(old);
    old.updateAll((key, value) => update[key] ?? value);
    update.forEach((key, value) {
      old.putIfAbsent(key, () => value);
    });
    String collectionName = data.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    return await collections[collectionName]
        ?.findAndModify(query: oldSaved, update: old, returnNew: true);
  }

  delete(dynamic type, dynamic data) async {
    String collectionName = type.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    var result = await collections[collectionName]?.deleteOne(data);

    return result;
  }

  getAll(dynamic data) async {
    String collectionName = data.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    var result =
        await collections[collectionName]?.find(data.toJson()).toList();

    return result;
  }

  findBy(dynamic data) async {
    try {
      String collectionName = data.runtimeType.toString();
      collections.putIfAbsent(
          collectionName, () => database._db.collection(collectionName));
      var result = await collections[collectionName]?.findOne(data.toJson());
      return result ??
          {
            "error": (data is User)
                ? "Incorrect username or password"
                : "Nothing found"
          };
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  findById(dynamic data, String id) async {
    try {
      String collectionName = data.runtimeType.toString();
      collections.putIfAbsent(
          collectionName, () => database._db.collection(collectionName));
      var result = await collections[collectionName]
          ?.findOne({"_id": ObjectId.fromHexString(id)});

      return result;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
