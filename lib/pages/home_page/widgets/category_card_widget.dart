import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/pages/home_page/models/meal_category.dart';

class CategoryCardWidget extends StatelessWidget {
  final MealCategory category;
  const CategoryCardWidget({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 100.sp,
              width: 100.sp,
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange[100],
              ),
              child: CircleAvatar(
                foregroundImage: NetworkImage(
                  category.image,
                ),
              ),
            ),
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
