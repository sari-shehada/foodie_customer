// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:foodie/pages/home_page/models/restaurant.dart';
import 'package:foodie/pages/restaurant_page/models/meal.dart';

class RestaurantWithMeals {
  final Restaurant restaurant;
  final List<Meal> meals;
  RestaurantWithMeals({
    required this.restaurant,
    required this.meals,
  });

  RestaurantWithMeals copyWith({
    Restaurant? restaurant,
    List<Meal>? meals,
  }) {
    return RestaurantWithMeals(
      restaurant: restaurant ?? this.restaurant,
      meals: meals ?? this.meals,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurant': restaurant.toMap(),
      'meals': meals.map((x) => x.toMap()).toList(),
    };
  }

  factory RestaurantWithMeals.fromMap(Map<String, dynamic> map) {
    return RestaurantWithMeals(
      restaurant: Restaurant.fromMap(map['restaurant'] as Map<String, dynamic>),
      meals: List<Meal>.from(
        (map['meals'] as List).map<Meal>(
          (x) => Meal.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantWithMeals.fromJson(String source) =>
      RestaurantWithMeals.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RestaurantWithMeals(restaurant: $restaurant, meals: $meals)';

  @override
  bool operator ==(covariant RestaurantWithMeals other) {
    if (identical(this, other)) return true;

    return other.restaurant == restaurant && listEquals(other.meals, meals);
  }

  @override
  int get hashCode => restaurant.hashCode ^ meals.hashCode;
}
