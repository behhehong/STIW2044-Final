// ignore_for_file: non_constant_identifier_names

class Subscribe {
  String? subject_id;
  String? email;
  String? subscribe_date;

  Subscribe({this.subject_id, this.email, this.subscribe_date});

  Subscribe.fromJson(Map<String, dynamic> json) {
    subject_id = json["subject_id"];
    email = json["email"];
    subscribe_date = json["subscribe_date"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subject_id;
    data['email'] = email;
    data['subscribe_date'] = subscribe_date;
    return data;
  }
}
