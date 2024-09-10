// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? userId;
  final String? name;
  final String? isLogin;
  final String? email;

  User({
    this.userId,
    this.name,
    this.isLogin,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        name: json["name"],
        isLogin: json["is_login"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "is_login": isLogin,
        "email": email,
      };
}
