// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:foodie/core/exceptions/factory_map_exception.dart';

class SignUpFormData {
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String phoneNumber;
  SignUpFormData({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.phoneNumber,
  });

  SignUpFormData copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? phoneNumber,
  }) {
    return SignUpFormData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }

  factory SignUpFormData.fromMap(Map<String, dynamic> map) {
    try {
      return SignUpFormData(
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        phoneNumber: map['phoneNumber'] as String,
      );
    } catch (e) {
      throw FactoryMapException(
        map: map,
        message:
            'SignUpFormData Failed to Convert Map to Object, Error Message: $e',
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory SignUpFormData.fromJson(String source) =>
      SignUpFormData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignUpFormData(firstName: $firstName, lastName: $lastName, username: $username, password: $password, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant SignUpFormData other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.password == password &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        username.hashCode ^
        password.hashCode ^
        phoneNumber.hashCode;
  }
}
