import 'package:urawai_pos/core/Enums/user_roles.dart';

class Users {
  String id;
  String username;
  String email;
  String shopName;
  UserRole roles;

  Users(this.id, this.shopName, this.username, this.email, this.roles);

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    shopName = json['shopName'];
    email = json['email'];
  }
}
