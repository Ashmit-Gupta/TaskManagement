import 'dart:convert';
/// name : "test user"
/// email : "mainhibatarha@gmail.com"
/// password : "123456"

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  UserModel({
      String? name, 
      String? email, 
      String? password,}){
    _name = name;
    _email = email;
    _password = password;
}

  UserModel.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _password = json['password'];
  }
  String? _name;
  String? _email;
  String? _password;
UserModel copyWith({  String? name,
  String? email,
  String? password,
}) => UserModel(  name: name ?? _name,
  email: email ?? _email,
  password: password ?? _password,
);
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }

}