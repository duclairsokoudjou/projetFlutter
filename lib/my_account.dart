import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';

import 'custom_scaffold.dart';

class MyAccount extends StatelessWidget {
  const MyAccount ({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("My Account")),
      ),
      showBottomNavBar: true,
      initialIndex: 2,
    );
  }
}
