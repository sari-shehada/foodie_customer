import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/cart_helper/cart_helper.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/pages/loader_page/loader_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  CartHelper.init();
  await ScreenUtil.ensureScreenSize();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: false,
      useInheritedMediaQuery: true,
      designSize: const Size(390, 844),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Foodie',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
          ),
          home: const LoaderPage(),
        );
      },
    );
  }
}
