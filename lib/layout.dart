import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:social_media/Providers/user_provider.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:social_media/screens/add_screen.dart';
import 'package:social_media/screens/home_screen.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/screens/search_screen.dart';

class LayOutScreen extends StatefulWidget {
  const LayOutScreen({super.key});

  @override
  State<LayOutScreen> createState() => _LayOutScreenState();
}

class _LayOutScreenState extends State<LayOutScreen> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context, listen: false).getDetails();
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      const HomeScreen(),
      const AddScreen(),
      const SearchScreen(),
      ProfileScreen(),
    ];

    return Provider.of<UserProvider>(context).isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: pages[_page],
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0,
              items: [
                Icon(Icons.home, size: 30, color: kSocunderyColor),
                Icon(Icons.add, size: 30, color: kSocunderyColor),
                Icon(Icons.search, size: 30, color: kSocunderyColor),
                Icon(Icons.person, size: 30, color: kSocunderyColor),
              ],
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 600),
              onTap: (index) {
                setState(() {
                  _page = index;
                });
              },
              letIndexChange: (index) => true,
            ),
          );
  }
}
