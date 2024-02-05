// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:foodie/pages/restaurant_page/models/meal.dart';

class UserMeal {
  final Meal meal;
  final bool isInFavorites;
  final int? myRating;
  UserMeal({
    required this.meal,
    required this.isInFavorites,
    this.myRating,
  });

  UserMeal copyWith({
    Meal? meal,
    bool? isInFavorites,
    int? myRating,
  }) {
    return UserMeal(
      meal: meal ?? this.meal,
      isInFavorites: isInFavorites ?? this.isInFavorites,
      myRating: myRating ?? this.myRating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meal': meal.toMap(),
      'isInFavorites': isInFavorites,
      'myRating': myRating,
    };
  }

  factory UserMeal.fromMap(Map<String, dynamic> map) {
    return UserMeal(
      meal: Meal.fromMap(map),
      isInFavorites: map['isInFavorites'] as bool,
      myRating: map['myRating'] != null ? map['myRating'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMeal.fromJson(String source) =>
      UserMeal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserMeal(meal: $meal, isInFavorites: $isInFavorites, myRating: $myRating)';

  @override
  bool operator ==(covariant UserMeal other) {
    if (identical(this, other)) return true;

    return other.meal == meal &&
        other.isInFavorites == isInFavorites &&
        other.myRating == myRating;
  }

  @override
  int get hashCode =>
      meal.hashCode ^ isInFavorites.hashCode ^ myRating.hashCode;
}
