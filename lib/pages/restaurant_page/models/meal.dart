// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Meal {
  int id;
  String name;
  num price;
  num? discountedPrice;
  int rating;
  String ingredients;
  int restaurant;
  int category;
  String image;
  Meal({
    required this.id,
    required this.name,
    required this.price,
    this.discountedPrice,
    required this.rating,
    required this.ingredients,
    required this.restaurant,
    required this.category,
    required this.image,
  });

  Meal copyWith({
    int? id,
    String? name,
    num? price,
    num? discountedPrice,
    int? rating,
    String? ingredients,
    int? restaurant,
    int? category,
    String? image,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      rating: rating ?? this.rating,
      ingredients: ingredients ?? this.ingredients,
      restaurant: restaurant ?? this.restaurant,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'discountedPrice': discountedPrice,
      'rating': rating,
      'ingredients': ingredients,
      'restaurant': restaurant,
      'category': category,
      'image': image,
    };
  }

  int calculateTotalPrice(int qty) {
    int finalPrice = (discountedPrice ?? price).toInt();
    return qty * finalPrice;
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as num,
      discountedPrice:
          map['discountedPrice'] != null ? map['discountedPrice'] as num : null,
      rating: map['rating'] as int,
      ingredients: map['ingredients'] as String,
      restaurant: map['restaurant'] as int,
      category: map['category'] as int,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meal.fromJson(String source) =>
      Meal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Meal(id: $id, name: $name, price: $price, discountedPrice: $discountedPrice, rating: $rating, ingredients: $ingredients, restaurant: $restaurant, category: $category, image: $image)';
  }

  @override
  bool operator ==(covariant Meal other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.price == price &&
        other.discountedPrice == discountedPrice &&
        other.rating == rating &&
        other.ingredients == ingredients &&
        other.restaurant == restaurant &&
        other.category == category &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        discountedPrice.hashCode ^
        rating.hashCode ^
        ingredients.hashCode ^
        restaurant.hashCode ^
        category.hashCode ^
        image.hashCode;
  }
}
