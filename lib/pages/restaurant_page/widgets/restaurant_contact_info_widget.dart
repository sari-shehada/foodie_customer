import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantContactInfoWidget extends StatelessWidget {
  const RestaurantContactInfoWidget({
    super.key,
    required this.iconData,
    required this.number,
    required this.onButtonTap,
  });

  final IconData iconData;
  final String number;
  final VoidCallback onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 26.sp,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(number),
        const Spacer(),
        FilledButton(
          onPressed: onButtonTap,
          child: const Text('Make a phone call'),
        ),
      ],
    );
  }
}
