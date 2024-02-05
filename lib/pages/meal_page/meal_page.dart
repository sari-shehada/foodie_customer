import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/cart_helper/cart_helper.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/meal_page/models/user_meal.dart';

class MealPage extends StatefulWidget {
  const MealPage({
    super.key,
    required this.mealId,
  });
  final int mealId;
  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  late Future<UserMeal> futureMeal;
  @override
  void initState() {
    futureMeal = getMealDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
      ),
      body: CustomFutureBuilder(
        future: futureMeal,
        builder: (context, meal) {
          return MealPageBody(
            meal: meal,
            rateMealCallback: () => rateMeal(),
          );
        },
      ),
    );
  }

  Future<void> rateMeal() async {}

  Future<UserMeal> getMealDetails() async {
    int userId = SharedPreferencesService.instance.getInt('userId') ?? -1;
    return HttpService.parsedGet(
      endPoint: 'meals/${widget.mealId}/',
      queryParams: {
        'userId': userId.toString(),
      },
      mapper: UserMeal.fromJson,
    );
  }
}

class MealPageBody extends StatefulWidget {
  const MealPageBody({
    super.key,
    required this.meal,
    required this.rateMealCallback,
  });

  final UserMeal meal;
  final VoidCallback rateMealCallback;

  @override
  State<MealPageBody> createState() => _MealPageBodyState();
}

class _MealPageBodyState extends State<MealPageBody> {
  late bool isAddedToCart;
  late int currentItemQty;

  @override
  void initState() {
    isAddedToCart = CartHelper.instance.isItemInCart(widget.meal.meal);
    if (CartHelper.instance.isItemInCart(widget.meal.meal)) {
      currentItemQty =
          CartHelper.instance.mealsInCart[widget.meal.meal.id] ?? 0;
    } else {
      currentItemQty = 0;
    }
    CartHelper.instance.addListener(
      () {
        if (mounted) {
          isAddedToCart = CartHelper.instance.isItemInCart(widget.meal.meal);
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            flex: 45,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(widget.meal.meal.image),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    widget.meal.meal.name,
                    style: TextStyle(
                      fontSize: 19.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 27.sp,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        widget.meal.meal.rating.toString(),
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 55,
            child: Column(
              children: [
                Text(widget.meal.meal.ingredients),
                SizedBox(
                  height: 20.h,
                ),
                widget.meal.myRating != null
                    ? Column(
                        children: [
                          RatingBar.builder(
                            maxRating: 5,
                            minRating: 0,
                            initialRating: widget.meal.myRating!.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (value) {},
                            allowHalfRating: false,
                            ignoreGestures: true,
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: widget.rateMealCallback,
                            child: const Text(
                              'Change meal rating',
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: widget.rateMealCallback,
                        child: const Text(
                          'Rate this meal',
                        ),
                      ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Price for this meal:',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          const Spacer(),
                          Text(
                            widget.meal.meal.price.toString(),
                            style: TextStyle(
                              decoration:
                                  widget.meal.meal.discountedPrice != null
                                      ? TextDecoration.lineThrough
                                      : null,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            width: widget.meal.meal.discountedPrice == null
                                ? 0
                                : 10.w,
                          ),
                          Text(
                            '${widget.meal.meal.discountedPrice ?? ''} SYP',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isAddedToCart
                              ? 'Meal already in cart'
                              : 'Add meal to cart',
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (currentItemQty > 0) {
                                currentItemQty--;
                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                            ),
                          ),
                          Text(currentItemQty.toString()),
                          IconButton(
                            onPressed: () {
                              currentItemQty++;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => addOrUpdateCart(),
                        child: Text(
                          isAddedToCart ? 'Update cart' : 'Add to cart',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addOrUpdateCart() async {
    await CartHelper.instance.addMealToCart(widget.meal.meal, currentItemQty);
  }
}
