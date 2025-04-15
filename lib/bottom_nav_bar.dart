import 'package:flutter/material.dart';
import 'package:login/home_screen.dart';

import 'food.dart';
import 'my_account.dart';
import 'my_cart.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({super.key, required this.initialIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  var _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.initialIndex;
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index){
      case 0:
        _navigateToRoute(context, '/home', HomeScreen());
        break;
      case 1:
        _navigateToRoute(context, '/Reviews', Food());
        break;
      case 2:
        _navigateToRoute(context, '/myaccount', MyAccount());
        break;
      case 3:
        _navigateToRoute(context, '/mycart', MyCart());
        break;
    }
  }

  void _navigateToRoute(context, String routeNane, Widget screen) {
    final String ? currentRouteName = ModalRoute.of(context)?.settings.name;
    bool routeExists = currentRouteName == routeNane;

    if(routeExists){
      Navigator.popUntil(context, ModalRoute.withName(routeNane));
    }else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => screen,
              settings: RouteSettings(name: routeNane),
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: _selectedIndex == 0 ? Colors.green : Colors.black
          ),
        label: 'Home'
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.reviews_outlined,
            color: _selectedIndex == 1 ? Colors.green : Colors.black,
          ),
          label: 'Reviews'
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.person_2_outlined,
            color: _selectedIndex == 2 ? Colors.green : Colors.black,
          ),
          label: 'My Account'
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: _selectedIndex == 3 ? Colors.green : Colors.black,
          ),
          label: 'My Cart'
      ),
    ]);
  }
}
