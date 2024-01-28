// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginFormData {
  final String username;
  final String password;
  LoginFormData({
    required this.username,
    required this.password,
  });

  LoginFormData copyWith({
    String? username,
    String? password,
  }) {
    return LoginFormData(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  factory LoginFormData.fromMap(Map<String, dynamic> map) {
    return LoginFormData(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginFormData.fromJson(String source) =>
      LoginFormData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoginFormData(username: $username, password: $password)';

  @override
  bool operator ==(covariant LoginFormData other) {
    if (identical(this, other)) return true;

    return other.username == username && other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}
