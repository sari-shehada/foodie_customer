import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/config/colors.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/home_page/models/restaurant.dart';
import 'package:foodie/pages/meal_page/meal_page.dart';
import 'package:foodie/pages/restaurant_page/models/meal.dart';
import 'package:foodie/pages/restaurant_page/models/restaurant_meals.dart';
import 'package:foodie/pages/restaurant_page/widgets/restaurant_contact_info_widget.dart';

import '../../core/services/url_launcher_service.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({
    super.key,
    required this.restaurant,
  });
  final Restaurant restaurant;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late Future<List<RestaurantMealsCategory>> futureMealCategories;

  @override
  void initState() {
    futureMealCategories = getMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox.square(
              dimension: 37.sp,
              child: Image(
                image: NetworkImage(widget.restaurant.image),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(widget.restaurant.name),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Column(
                children: [
                  if (widget.restaurant.phoneNumber != null)
                    RestaurantContactInfoWidget(
                      iconData: Icons.smartphone,
                      number: widget.restaurant.phoneNumber!,
                      onButtonTap: () => UrlLauncherService.openPhoneDialer(
                        phoneNumber: widget.restaurant.phoneNumber,
                      ),
                    ),
                  if (widget.restaurant.landLine != null)
                    RestaurantContactInfoWidget(
                      iconData: Icons.phone,
                      number: widget.restaurant.landLine!,
                      onButtonTap: () => UrlLauncherService.openPhoneDialer(
                        phoneNumber: '011${widget.restaurant.landLine}',
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: CustomFutureBuilder(
                future: futureMealCategories,
                builder: (context, mealsCategories) {
                  return ListView.builder(
                    itemCount: mealsCategories.length,
                    itemBuilder: (context, index) {
                      RestaurantMealsCategory mealsCategory =
                          mealsCategories[index];
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              children: [
                                Text(
                                  '- ${mealsCategory.category.name}',
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.5.h,
                                    width: double.maxFinite,
                                    color:
                                        AppColors.primaryColor.withOpacity(0.5),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ...List.generate(
                            mealsCategory.meals.length,
                            (index1) {
                              Meal meal = mealsCategory.meals[index1];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: ListTile(
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
                                  title: Text(meal.name),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<RestaurantMealsCategory>> getMeals() async {
    return HttpService.parsedMultiGet(
      endPoint: 'restaurants/${widget.restaurant.id}/meals/',
      mapper: RestaurantMealsCategory.fromMap,
    );
  }
}
