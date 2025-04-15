import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';

import 'custom_scaffold.dart';

class MyAccount extends StatelessWidget {
  const MyAccount ({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomScaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.green[700]),
                  child: Padding(
                      padding: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'e-Commerce App',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'duclairsokoudjou@gmail.com',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'images/account.jpeg',
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Padding(
                    padding: EdgeInsets.all(10.0),
                  child: Text(
                    'My Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              ],
            ),
          )
      ),
      showBottomNavBar: true,
      initialIndex: 2,
    );
  }
}


