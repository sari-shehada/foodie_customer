import 'package:flutter/material.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/home_page/models/restaurant.dart';
import 'package:foodie/pages/home_page/widgets/restaurant_card_widget.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({
    super.key,
    required this.searchTerm,
  });

  final String searchTerm;
  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<Restaurant>> results;

  @override
  void initState() {
    results = getSearchResults(widget.searchTerm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: SizedBox.expand(
        child: CustomFutureBuilder(
          future: results,
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
    );
  }

  Future<List<Restaurant>> getSearchResults(String searchTerm) async {
    return HttpService.parsedMultiGet(
      endPoint: 'restaurants/search/',
      queryParams: {
        'search': searchTerm,
      },
      mapper: Restaurant.fromMap,
    );
  }
}
