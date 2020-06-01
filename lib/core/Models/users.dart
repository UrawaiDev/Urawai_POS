class Users {
  String id;
  String username;
  String email;
  String shopName;
  String role;

  Users(this.id, this.shopName, this.username, this.email, this.role);

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    shopName = json['shopname'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'shopname': shopName,
      'email': email,
      'role': role,
    };
  }
}
