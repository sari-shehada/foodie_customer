import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    if (qty == 0) {
      if (mealsInCart.keys.contains(meal.id)) {
        mealsInCart.remove(meal.id);
        await updateAndNotify(isItemRemoved: true);
      }
      return;
    }
    currentRestaurantId ??= meal.restaurant;
    if (meal.restaurant != currentRestaurantId) {
      var result = await Get.dialog(
        const ResetCartWithAnotherRestaurantConfirmationDialog(),
      );
      if (result != true) {
        return;
      }
      changeRestaurant(meal.restaurant);
    }
    mealsInCart[meal.id] = qty;
    await updateAndNotify();
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

  Future<void> updateAndNotify({
    bool isItemRemoved = false,
  }) async {
    await updateStorage();
    SnackBarService.showSuccessSnackbar(
      'Meal ${isItemRemoved ? 'removed from' : 'added to'} cart',
    );
    notifyListeners();
  }
}

class ResetCartWithAnotherRestaurantConfirmationDialog extends StatelessWidget {
  const ResetCartWithAnotherRestaurantConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Restaurant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Your cart contains items from another restaurant, if you continue you will lose the items currently in your cart, would you like to proceed?',
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Proceed',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
