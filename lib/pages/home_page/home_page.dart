import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/cart_helper/cart_helper.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/cart_page/cart_page.dart';
import 'package:foodie/pages/home_page/models/meal_category.dart';
import 'package:foodie/pages/home_page/models/restaurant.dart';
import 'package:foodie/pages/home_page/widgets/category_card_widget.dart';
import 'package:foodie/pages/home_page/widgets/home_page_drawer.dart';
import 'package:foodie/pages/home_page/widgets/restaurant_card_widget.dart';
import 'package:foodie/pages/search_results_page/search_results_page.dart';

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
      drawer: const HomePageDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        foregroundColor: Colors.orange,
        title: Container(
          padding: EdgeInsets.only(left: 15.0.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
              suffixIcon: Icon(Icons.search),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              NavigationService.push(
                context,
                SearchResultsPage(searchTerm: value),
              );
            },
          ),
        ),
        actions: const [
          HomePageCartIconWidget(),
        ],
      ),
      body: Column(
        children: [
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

class HomePageCartIconWidget extends StatefulWidget {
  const HomePageCartIconWidget({super.key});

  @override
  State<HomePageCartIconWidget> createState() => _CartHomePageIconStateWidget();
}

class _CartHomePageIconStateWidget extends State<HomePageCartIconWidget> {
  int cartItems = 0;
  @override
  void initState() {
    updateCartItemsQTY();
    CartHelper.instance.addListener(() {
      if (mounted) {
        updateCartItemsQTY();
        setState(() {});
      }
    });
    super.initState();
  }

  void updateCartItemsQTY() {
    cartItems = CartHelper.instance.mealsInCart.keys.length;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge(
        label: Text(
          cartItems.toString(),
        ),
        isLabelVisible: cartItems != 0,
        child: const Icon(
          Icons.shopping_cart,
        ),
      ),
      onPressed: () => NavigationService.push(
        context,
        const CartPage(),
      ),
    );
  }
}
