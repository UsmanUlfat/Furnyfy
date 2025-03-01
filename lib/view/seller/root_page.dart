import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:furniy_ar/view/seller/cart_page.dart';
import 'package:furniy_ar/view/seller/favorite_page.dart';
import 'package:furniy_ar/view/seller/home_page.dart';
import 'package:furniy_ar/view/seller/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:furniy_ar/view/seller/scan_page.dart';

import 'package:page_transition/page_transition.dart';

import '../../model/Favorite.dart';
import '../../utils/constants.dart';
import 'ar_screen.dart';
import 'ar_selectmodel.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Furniture> favorites = [];
  List<Furniture> myCart = [];

  int _bottomNavIndex = 0;

  //List of the pages
  List<Widget> _widgetOptions() {
    return [
      const HomePage(),
      FavoritePage(
        favoritedFurnitures: favorites,
      ),
      CartPage(
        addedToCartFurnitures: myCart,
      ),
      const ProfilePage(),
    ];
  }

  //List of the pages icons
  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
  ];

  //List of the pages titles
  List<String> titleList = [
    'Home',
    'Favorite',
    'Cart',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleList[_bottomNavIndex],
              style: TextStyle(
                color: Constants.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            Icon(
              Icons.notifications,
              color: Constants.blackColor,
              size: 30.0,
            )
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _widgetOptions(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArSelectmodel()));

        },
        backgroundColor: Constants.primaryColor,
        child: Image.asset(
          'assets/images/code-scan-two.png',
          height: 30.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: Constants.primaryColor,
          activeColor: Constants.primaryColor,
          inactiveColor: Colors.black.withOpacity(.5),
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
              final List<Furniture> favoritedFurnitures = Furniture.getFavoritedFurnitures();
              final List<Furniture> addedToCartFurnitures = Furniture.addedToCartFurnitures();

              favorites = favoritedFurnitures;
              myCart = addedToCartFurnitures.toSet().toList();
            });
          }),
    );
  }
}
