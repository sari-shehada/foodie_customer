import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/core/widgets/custom_future_builder.dart';
import 'package:foodie/pages/about_page/about_page.dart';
import 'package:foodie/pages/login_page/login_page.dart';
import 'package:foodie/pages/login_page/models/user_info.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({super.key});

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  late Future<UserInfo> futureMyInfo;

  Future<UserInfo> getMyInfo() async {
    int? userId = SharedPreferencesService.instance.getInt('userId');
    if (userId == null) {
      NavigationService.pushAndPopAll(
        context,
        const LoginPage(),
      );
    }
    return HttpService.parsedGet(
      endPoint: 'users/$userId/',
      mapper: UserInfo.fromJson,
    );
  }

  @override
  void initState() {
    futureMyInfo = getMyInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
          children: [
            SizedBox(
              height: 180.h,
              child: CustomFutureBuilder(
                future: futureMyInfo,
                builder: (context, myInfo) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(
                      '${myInfo.firstName} ${myInfo.lastName}',
                      style:
                          const TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    accountEmail: Text(
                      '@${myInfo.username}',
                      style: const TextStyle(color: Colors.black26),
                    ),
                    currentAccountPicture: GestureDetector(
                      child: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: const ListTile(
                      title: Text("Home Page"),
                      leading: Icon(
                        Icons.home,
                        color: Colors.orange,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const CategoryPage()));
                    // },
                    child: const ListTile(
                      title: Text("Menu"),
                      leading: Icon(
                        Icons.restaurant,
                        color: Colors.orange,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),

            Theme(
              data: theme,
              child: ExpansionTile(
                title: const Text("My Profile"),
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const MyProfile()));
                      // },
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text("Change Myprofile"),
                            leading: Icon(
                              Icons.settings,
                              color: Colors.orange,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                          Divider(
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //=====================================end child account
                  Container(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const ChangePassword()));
                      // },
                      child: const Column(
                        children: [
                          ListTile(
                            title: Text("Change Password"),
                            leading: Icon(
                              Icons.settings,
                              color: Colors.orange,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //===================================child account
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Divider(
                color: Colors.grey[500],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: InkWell(
                // onTap: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const Favorite()));
                // },
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("My Favorait"),
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.orange,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutPage()));
                    },
                    child: const ListTile(
                      title: Text("About Us"),
                      leading: Icon(
                        Icons.message,
                        color: Colors.orange,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      title: Text("Support Center"),
                      leading: Icon(
                        Icons.call,
                        color: Colors.orange,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
