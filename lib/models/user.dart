class User {
  String? userId;
  String? username;
  String? phoneNum;
  String? address;
  String? email;
  String? password;
  String? datereg;
  String? cart;

  User(
      {this.userId,
      this.username,
      this.phoneNum,
      this.address,
      this.email,
      this.password,
      this.datereg,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    username = json["username"];
    phoneNum = json["phoneNum"];
    address = json["address"];
    email = json["email"];
    password = json["password"];
    datereg = json["datereg"];
    cart = json["cart"].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['username'] = username;
    data['phoneNum'] = phoneNum;
    data['address'] = address;
    data['email'] = email;
    data['password'] = password;
    data['datereg'] = datereg;
    data['cart'] = cart.toString();
    return data;
  }
}
