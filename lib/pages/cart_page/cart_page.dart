import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/cart_helper/cart_helper.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/services/url_launcher_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/cart_page/models/resturant_with_meals.dart';
import 'package:foodie/pages/meal_page/meal_page.dart';
import 'package:foodie/pages/restaurant_page/models/meal.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<RestaurantWithMeals> cartItems;

  @override
  void initState() {
    cartItems = getCartItems();
    CartHelper.instance.addListener(() {
      if (mounted) {
        cartItems = getCartItems();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: CartHelper.instance.mealsInCart.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : SizedBox.expand(
              child: CustomFutureBuilder(
                future: cartItems,
                builder: (context, snapshot) => CartPageBodyWidget(
                  cartItems: snapshot,
                  removeItemCallback: (meal) => removeItemFromCart(meal),
                ),
              ),
            ),
    );
  }

  Future<void> removeItemFromCart(Meal meal) async {
    await CartHelper.instance.addMealToCart(meal, 0);
  }

  Future<RestaurantWithMeals> getCartItems() async {
    return HttpService.parsedGet(
      endPoint: 'getCartItems/',
      queryParams: {
        'restaurantId':
            CartHelper.instance.currentRestaurantId?.toString() ?? '-1',
        'mealIds': jsonEncode(
          CartHelper.instance.mealsInCart.keys
              .map((e) => e.toString())
              .toList(),
        ),
      },
      mapper: RestaurantWithMeals.fromJson,
    );
  }
}

class CartPageBodyWidget extends StatelessWidget {
  const CartPageBodyWidget({
    super.key,
    required this.cartItems,
    required this.removeItemCallback,
  });

  final RestaurantWithMeals cartItems;
  final Function(Meal meal) removeItemCallback;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  cartItems.restaurant.image,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                cartItems.restaurant.name,
                style: TextStyle(
                  fontSize: 19.sp,
                  color: Colors.orange.shade700,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                'Current Restaurant',
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cartItems.restaurant.landLine != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9.w),
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.orange.shade100,
                          ),
                          iconColor: MaterialStatePropertyAll(
                            Colors.orange.shade600,
                          ),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.all(13.sp),
                          ),
                        ),
                        onPressed: () => UrlLauncherService.openPhoneDialer(
                          phoneNumber:
                              '011${cartItems.restaurant.landLine ?? ''}',
                        ),
                        icon: const Icon(
                          Icons.phone,
                        ),
                      ),
                    ),
                  if (cartItems.restaurant.phoneNumber != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9.w),
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.orange.shade100,
                          ),
                          iconColor: MaterialStatePropertyAll(
                            Colors.orange.shade600,
                          ),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.all(13.sp),
                          ),
                        ),
                        onPressed: () => UrlLauncherService.openPhoneDialer(
                          phoneNumber: cartItems.restaurant.phoneNumber,
                        ),
                        icon: const Icon(
                          Icons.smartphone,
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: ListView.builder(
            itemCount: cartItems.meals.length,
            itemBuilder: (context, index) {
              Meal meal = cartItems.meals[index];
              return ListTile(
                onTap: () => NavigationService.push(
                  context,
                  MealPage(
                    mealId: meal.id,
                  ),
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image.network(meal.image),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name),
                    Text(
                      'Quantity: ${CartHelper.instance.mealsInCart[meal.id]!}',
                    ),
                    Text(
                      'Total Price: ${meal.calculateTotalPrice(
                        CartHelper.instance.mealsInCart[meal.id]!,
                      )} SYP',
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () => removeItemCallback(meal),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.red.shade100,
                    ),
                    iconColor: MaterialStatePropertyAll(
                      Colors.red.shade600,
                    ),
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.all(5.sp),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
