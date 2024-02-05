import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/core/services/snackbar_service.dart';
import 'package:foodie/pages/restaurant_page/models/meal.dart';
import 'package:get/get.dart';

class CartHelper with ChangeNotifier {
  CartHelper({
    required this.currentRestaurantId,
    required this.mealsInCart,
  });

  int? currentRestaurantId;

  //First int is for the id of the meal, the other is for quantity
  Map<int, int> mealsInCart;

  static late CartHelper instance;

  static CartHelper init() {
    String? cartItemsAsString =
        SharedPreferencesService.instance.getString('cartItems');
    int? restaurantId =
        SharedPreferencesService.instance.getInt('cartRestaurantId');
    if (restaurantId == null || cartItemsAsString == null) {
      instance = CartHelper(
        currentRestaurantId: null,
        mealsInCart: {},
      );
    } else {
      instance = CartHelper(
        currentRestaurantId: restaurantId,
        mealsInCart: (jsonDecode(cartItemsAsString) as Map<String, dynamic>)
            .map<int, int>(
          (key, value) => MapEntry(
            int.parse(key),
            value as int,
          ),
        ),
      );
    }
    return instance;
  }

  Future<void> addMealToCart(Meal meal, int qty) async {
    currentRestaurantId ??= meal.restaurant;
    if (meal.restaurant != currentRestaurantId) {
      var result = await Get.dialog(
        const ResetCartWithAnotherRestaurantConfirmationDialog(),
      );
      if (result == false) {
        return;
      }
      changeRestaurant(meal.restaurant);
    }
    mealsInCart[meal.id] = qty;
    await updateStorage();
    SnackBarService.showSuccessSnackbar('Meal added to cart');
    notifyListeners();
  }

  void changeRestaurant(int newRestaurantId) {
    currentRestaurantId = newRestaurantId;
    mealsInCart.clear();
  }

  Future<void> updateStorage() async {
    SharedPreferencesService.instance.setInt(
      key: 'cartRestaurantId',
      value: currentRestaurantId ?? -1,
    );
    SharedPreferencesService.instance.setString(
      key: 'cartItems',
      value: jsonEncode(
        mealsInCart.map<String, int>(
          (key, value) => MapEntry(key.toString(), value),
        ),
      ),
    );
  }

  bool isItemInCart(Meal meal) {
    return meal.restaurant == currentRestaurantId &&
        mealsInCart.containsKey(meal.id);
  }
}

class ResetCartWithAnotherRestaurantConfirmationDialog extends StatelessWidget {
  const ResetCartWithAnotherRestaurantConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
