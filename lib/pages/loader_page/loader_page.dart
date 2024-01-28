import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/config/colors.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/pages/home_page/home_page.dart';
import 'package:foodie/pages/login_page/login_page.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        loadApp(context);
      },
    );
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_logo.webp',
              height: 170.sp,
              width: 170.sp,
            ),
            SizedBox(
              height: 60.h,
            ),
            Text(
              'Foodie',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 32.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadApp(BuildContext context) async {
    int? userId = SharedPreferencesService.instance.getInt('userId');
    if (userId == null) {
      NavigationService.pushAndPopAll(
        context,
        const LoginPage(),
      );
      return;
    }
    NavigationService.pushAndPopAll(
      context,
      const HomePage(),
    );
  }
}
