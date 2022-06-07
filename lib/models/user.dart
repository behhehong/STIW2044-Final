class User {
  String? username;
  String? phoneNum;
  String? address;
  String? email;
  String? password;
  String? datereg;

  User(
      {this.username,
      this.phoneNum,
      this.address,
      this.email,
      this.password,
      this.datereg});

  User.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    phoneNum = json["phoneNum"];
    address = json["address"];
    email = json["email"];
    password = json["password"];
    datereg = json["datereg"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['phoneNum'] = phoneNum;
    data['address'] = address;
    data['email'] = email;
    data['password'] = password;
    data['datereg'] = datereg;
    return data;
  }
}
