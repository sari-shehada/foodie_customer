// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Restaurant {
  int id;
  String name;
  String location;
  String? phoneNumber;
  String? landLine;
  String image;
  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.landLine,
    required this.image,
  });

  Restaurant copyWith({
    int? id,
    String? name,
    String? location,
    String? phoneNumber,
    String? landLine,
    String? image,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      landLine: landLine ?? this.landLine,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
      'phoneNumber': phoneNumber,
      'landLine': landLine,
      'image': image,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as int,
      name: map['name'] as String,
      location: map['location'] as String,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      landLine: map['landLine'] != null ? map['landLine'] as String : null,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) =>
      Restaurant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, location: $location, phoneNumber: $phoneNumber, landLine: $landLine, image: $image)';
  }

  @override
  bool operator ==(covariant Restaurant other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.location == location &&
        other.phoneNumber == phoneNumber &&
        other.landLine == landLine &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        phoneNumber.hashCode ^
        landLine.hashCode ^
        image.hashCode;
  }
}
