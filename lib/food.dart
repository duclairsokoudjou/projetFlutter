import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';

import 'custom_scaffold.dart';

class Food extends StatelessWidget {
  const Food ({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.green[700]),
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon : Icon(Icons.search),
                            ),

                        )
                    ),
                    IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.filter_list)
                    ),
                  ],
                ),
              ),

            ),

          ],
        )
      ),
      showBottomNavBar: true,
      initialIndex: 1,
    );
  }
}

class FoodItem{
  final String image;
  final String title;
  final String subtitle;
  final double rating;
  final double price;

  FoodItem({
  required this.image,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.price
  });
}
