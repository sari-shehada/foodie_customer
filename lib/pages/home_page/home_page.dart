import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/home_page/models/meal_category.dart';
import 'package:foodie/pages/home_page/models/restaurant.dart';
import 'package:foodie/pages/home_page/widgets/category_card_widget.dart';
import 'package:foodie/pages/home_page/widgets/restaurant_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<MealCategory>> futureCategories;
  late Future<List<Restaurant>> futureRestaurants;

  @override
  void initState() {
    futureCategories = getCategories();
    futureRestaurants = getRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MyDrawer(), //TODO:
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            const SizedBox(
              width: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    //TODO:
                    // onTap: () {
                    //   KeyDrawer.currentState!.openEndDrawer();
                    // },
                    child: const Icon(
                      Icons.menu,
                      color: Colors.orange,
                      size: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25.0)),
                      child: const TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "search",
                              suffixIcon: Icon(Icons.search))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140.0.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: Offset(0, 30.h),
                  ),
                ],
              ),
              child: CustomFutureBuilder(
                future: futureCategories,
                builder: (context, categories) {
                  return ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryCardWidget(
                        category: categories[index],
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                width: MediaQuery.of(context).size.width,
                height: 320.0,
                child: CustomFutureBuilder(
                  future: futureRestaurants,
                  builder: (context, restaurants) {
                    return ListView.builder(
                      itemCount: restaurants.length,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, index) {
                        return RestaurantCardWidget(
                          restaurant: restaurants[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        selectedFontSize: 14,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 30.0,
            ),
            label: "notifications",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: ((context) => const OffersPage())));
              },
              icon: const Icon(
                Icons.restaurant_menu,
                size: 30.0,
              ),
            ),
            label: "offers",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            label: "myaccount",
          )
        ],
      ),
    );
  }

  Future<List<MealCategory>> getCategories() async {
    return HttpService.parsedMultiGet(
      endPoint: 'categories/',
      mapper: MealCategory.fromMap,
    );
  }

  Future<List<Restaurant>> getRestaurants() async {
    return HttpService.parsedMultiGet(
      endPoint: 'restaurants/',
      mapper: Restaurant.fromMap,
    );
  }
}
