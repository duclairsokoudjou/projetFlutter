import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';

import 'custom_scaffold.dart';

class MyCart extends StatelessWidget {
  const MyCart ({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("My Cart")),
      ),
      showBottomNavBar: true,
      initialIndex: 3,
    );
  }
}
