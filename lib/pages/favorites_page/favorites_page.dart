import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/cart_page/models/resturant_with_meals.dart';
import 'package:foodie/pages/home_page/widgets/restaurant_card_widget.dart';
import 'package:foodie/pages/restaurant_page/models/meal.dart';
import 'package:foodie/pages/restaurant_page/restaurant_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<RestaurantWithMeals>> favorites;

  @override
  void initState() {
    favorites = getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: SizedBox.expand(
        child: CustomFutureBuilder(
          future: favorites,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.length,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              itemBuilder: (context, index) {
                return FavoritesRestaurantWidget(
                  restaurant: snapshot[index],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<RestaurantWithMeals>> getFavorites() async {
    int? userId = SharedPreferencesService.instance.getInt('userId');
    if (userId == null) {
      throw Exception('No user id found in storage');
    }
    return await HttpService.parsedMultiGet(
      endPoint: 'users/$userId/favorites/',
      mapper: RestaurantWithMeals.fromMap,
    );
  }
}

class FavoritesRestaurantWidget extends StatelessWidget {
  const FavoritesRestaurantWidget({
    super.key,
    required this.restaurant,
  });

  final RestaurantWithMeals restaurant;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 10.h),
      child: Column(
        children: [
          RestaurantCardWidget(
            restaurant: restaurant.restaurant,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Text(
                        'Meals',
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Container(
                          height: 1.h,
                          width: double.maxFinite,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                ...List.generate(
                  restaurant.meals.length,
                  (index1) {
                    Meal meal = restaurant.meals[index1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: MealCardWidget(meal: meal),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
