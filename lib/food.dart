import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';

import 'custom_scaffold.dart';

class Food extends StatelessWidget {
  const Food ({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("Food")),
      ),
      showBottomNavBar: true,
      initialIndex: 1,
    );
  }
}
