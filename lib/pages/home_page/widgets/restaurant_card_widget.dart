import 'package:flutter/material.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/pages/home_page/models/restaurant.dart';
import 'package:foodie/pages/restaurant_page/restaurant_page.dart';

class RestaurantCardWidget extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCardWidget({
    super.key,
    required this.restaurant,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => NavigationService.push(
        context,
        RestaurantPage(
          restaurant: restaurant,
        ),
      ),
      tileColor: Colors.orange.shade50,
      leading: Image.network(restaurant.image),
      title: Text(restaurant.name),
      subtitle: Text(restaurant.location),
    );
  }
}
