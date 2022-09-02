import 'dart:convert';

import 'base/collections.dart';

class User extends Coll {
  factory User.fromMap(Map<String, dynamic> json) => User(
        email: json['email'] as String,
        hashedPassword: json['hashed_password'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
      );
  User({
    required this.email,
    required this.hashedPassword,
    required this.name,
    required this.code,
  });

  final String email;
  final String hashedPassword;
  final String name;
  final String code;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'email': email,
        'code': code,
        'hashed_password': hashedPassword,
        'name': name,
      };
}
