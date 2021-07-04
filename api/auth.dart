import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';

import "../models/user.dart";
import 'jwt.dart';
import 'mongo_db.dart';

class UserAuthentication {
  final SECRET_KEY = Platform.environment["SECRET_KEY"] ?? "34klj23*&#jdhlj2s";
//middleware for token based ID
  getAuthenticatedUser(Request req) async {
    if (!req.headers.containsKey("Authorization") ||
        ((req.headers['Authorization'] ?? '') == ''))
      return Response.forbidden("NOT AUTHORIZED");

    final String token = req.headers["Authorization"] ?? '';

    var result = await TokenMaker.validateToken(token);
    if (result is String) {
      var userdata = await Collection().findBy(User(email: result));
      if (userdata['error'] != null) return null;
      return userdata;
    } else {
      return null;
    }

    /*  final userID = token.split("::")[0];
    final confirmation = token.split("::")[1];
    final validity = token.split("::")[2];

    final utctime = DateTime.now().toUtc();
    final _userID =
        String.fromCharCodes(userID.runes.map((e) => e + 7).toList().reversed);
    final _validity = String.fromCharCodes(
        validity.runes.map((e) => e + 7).toList().reversed);
    bool key = _hash("$userID$validity", SECRET_KEY) == confirmation;
    if (!key) return Response.forbidden("NOT AUTHORIZED");
    return Response.ok('authenticator $_userID $_validity');*/
  }

// input paramater match required paramater validation
  dynamic _validate(List<String> require, List<String> recieved) {
    for (var x in require) {
      if (!(recieved.contains(x))) {
        return x;
      }
    }

    return true;
  }

//hash generator
  String _hash(password, salt) {
    final key = utf8.encode(password);
    final bytes = utf8.encode(salt);

    final hmacsha256 = Hmac(sha256, key);
    var digest = hmacsha256.convert(bytes);
    return digest.toString();
  }

//add new user
  add(Request request,
      {List<String> requires = const ["email", "password", 'name']}) async {
    Map<String, dynamic> body = await request.body;

    var valid = _validate(requires, body.keys.toList());
    if (valid is String) return Response(400, body: "$valid is required");

    final String email = body["email"];
    if (valid is String) return Response(400, body: "$valid is required");
    //final String email = body["email"];
    final String password = body["password"];
    final String name = body["name"];

    final saltBytes = "$email$SECRET_KEY".codeUnits;
    final salt = base64.encode(saltBytes);
    final hashedPassword = _hash(password, salt);
    var user = await Collection().save(
        User(email: email, password: hashedPassword, name: name),
        check: {"email": email});
    if (user!['error'] == null) {
      return Response.ok(
          jsonEncode({"token": TokenMaker.createTokenForUser(email)}));
    } else
      return Response(400, body: jsonEncode(user));

    /* //token =username::Datetime::hashedPass[10]
    final userCode = userName.codeUnits;
    final username = String.fromCharCodes(userCode);
    final token = _hash(userName, salt);

    final utctime = DateTime.now().toUtc();
    final validity = "${utctime.year}${utctime.month}${utctime.day}";

    final _userID =
        String.fromCharCodes(username.runes.map((e) => e - 7).toList());
    final _validity =
        String.fromCharCodes(validity.runes.map((e) => e - 7).toList());

    final newToken =
        "$_userID::${_hash("$_userID$_validity", SECRET_KEY)}::$_validity";
    return Response.ok(newToken, headers: {"Authorization": newToken});*/
  }

  login(Request request,
      {List<String> requires = const [
        "email",
        "password",
      ]}) async {
    //get request body
    Map<String, dynamic> body = await request.body;

    //validate input
    var valid = _validate(requires, body.keys.toList());
    if (valid is String) return Response(400, body: "$valid is required");

    final String email = body["email"];
    final String password = body["password"];
    //find user in database
    final saltBytes = "$email$SECRET_KEY".codeUnits;
    final salt = base64.encode(saltBytes);
    final hashedPassword = _hash(password, salt);
    var user = await Collection().findBy(
      User(
        email: email,
        password: hashedPassword,
      ),
    );
    //user found -sending token
    if (user != null && user['error'] == null) {
      return Response.ok(
          jsonEncode({"token": TokenMaker.createTokenForUser(email)}));
    }
    //user not found
    else
      return Response(400, body: jsonEncode(user));

    /* //token =username::Datetime::hashedPass[10]
    final userCode = userName.codeUnits;
    final username = String.fromCharCodes(userCode);
    final token = _hash(userName, salt);

    final utctime = DateTime.now().toUtc();
    final validity = "${utctime.year}${utctime.month}${utctime.day}";

    final _userID =
        String.fromCharCodes(username.runes.map((e) => e - 7).toList());
    final _validity =
        String.fromCharCodes(validity.runes.map((e) => e - 7).toList());

    final newToken =
        "$_userID::${_hash("$_userID$_validity", SECRET_KEY)}::$_validity";
    return Response.ok(newToken, headers: {"Authorization": newToken});*/
  }

  update(Request req,
      {List<String> requires = const [
        "photo",
        "name",
      ]}) async {
    //middleware authentication
    var user = await getAuthenticatedUser(req);
    if (user == null) return Response.forbidden("Not Authorized");

    var data = await req.body;

    var valid = _validate(requires, data.keys.toList());
    if (valid is String) return Response(400, body: "$valid is required");

    var updatedData = await Collection().update(
        user,
        User(
          photo: data['photo'],
          name: data['name'],
        ));

    return Response.ok(jsonEncode(updatedData));
  }

  find(Request req,
      {List<String> requires = const [
        "id",
      ]}) async {
    var data = await req.body;

    var valid = _validate(requires, data.keys.toList());
    if (valid is String) return Response(400, body: "$valid is required");

    var result = await Collection().findById(User(), data['id']);
    if (result['error'] != null) return Response.ok("Not found");
    return Response.ok(jsonEncode(
        User.fromJson(jsonDecode(jsonEncode(result))).toJsonSecure()));
  }

  getAll(Request req) async {
    var result = await Collection().getAll(User());
    if (result != null) {
      var userlist =
          (result as List).map((e) => User.fromJson(jsonDecode(jsonEncode(e))));
      return Response.ok(jsonEncode(userlist.map((element) {
        return element.toJsonSecure();
      }).toList()));
    }
    return Response.internalServerError();
  }

  delete(Request req) async {
    var user = await getAuthenticatedUser(req);

    if (user == null) return Response.forbidden("Not Authorized");

    var result = await Collection().delete(User(), user);

    return Response.ok("okay $result");
  }

  updatePassword(Request req) async {
    //middleware authentication
    var user = await getAuthenticatedUser(req);
    if (user == null) return Response.forbidden("Not Authorized");
    var data = await req.body;
    var currentPass = data['password'];
    var newPass = data['newPassword'];
    final saltBytes = "${user['email']}$SECRET_KEY".codeUnits;
    final salt = base64.encode(saltBytes);
    final hashedPassword = _hash(currentPass, salt);
    if (hashedPassword == user['password']) {
      var updatedData = await Collection().update(
          user,
          User(
            password: _hash(newPass, salt),
          ));
      if (updatedData != null) {
        return Response.ok("Password updated!");
      }
    } else {
      return Response(400, body: "Password don't match.");
    }
  }
}

extension e on Request {
  get body async {
    try {
      return jsonDecode(
              await read().cast<List<int>>().transform(Utf8Decoder()).join())
          as Map<String, dynamic>;
    } catch (e) {
      print("ERROR PARSING BODY $e");
      return null;
    }
  }
}
