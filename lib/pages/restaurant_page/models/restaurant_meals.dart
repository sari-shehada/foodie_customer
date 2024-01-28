// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:foodie/pages/home_page/models/meal_category.dart';
import 'package:foodie/pages/restaurant_page/models/meal.dart';

class RestaurantMealsCategory {
  MealCategory category;
  List<Meal> meals;
  RestaurantMealsCategory({
    required this.category,
    required this.meals,
  });

  RestaurantMealsCategory copyWith({
    MealCategory? category,
    List<Meal>? meals,
  }) {
    return RestaurantMealsCategory(
      category: category ?? this.category,
      meals: meals ?? this.meals,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category.toMap(),
      'meals': meals.map((x) => x.toMap()).toList(),
    };
  }

  factory RestaurantMealsCategory.fromMap(Map<String, dynamic> map) {
    return RestaurantMealsCategory(
      category: MealCategory.fromMap(map),
      meals: List<Meal>.from(
        (map['meals'] as List).map<Meal>(
          (x) => Meal.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantMealsCategory.fromJson(String source) =>
      RestaurantMealsCategory.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RestaurantMeals(category: $category, meals: $meals)';

  @override
  bool operator ==(covariant RestaurantMealsCategory other) {
    if (identical(this, other)) return true;

    return other.category == category && listEquals(other.meals, meals);
  }

  @override
  int get hashCode => category.hashCode ^ meals.hashCode;
}
