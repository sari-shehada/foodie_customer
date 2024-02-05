import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Application '),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Foodie Food App',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 26),
          Text(
            'The application allows users to browse and discover a variety of restaurants available in their area. Detailed information about each restaurant is displayed, including the menu, opening hours, location, reviews, and ratings provided by previous customers.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 26),
          Text(
            'The application enables users to conveniently and easily order food online. Users can browse menus, select the items they want to order, choose the delivery method (home delivery or restaurant pickup), and make payment online or upon delivery.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 26),
          Text(
            'The application allows users to reserve a table at restaurants in advance. Users can specify the number of people and select the preferred date and time for the reservation. This helps save time and ensures a table is available upon arrival at the restaurant.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 26),
          Text(
            ' The application displays special offers and discounts from participating restaurants. Users can browse current offers, discounts, and coupons, and use them while ordering food or making reservations.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 36),
          Text(
            'Thank You For Your Visite',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          ),
          Icon(Icons.favorite_rounded)
        ],
      ),
    );
  }
}
