import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/home_screen.dart';
import 'package:login/sign_in.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword ({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 110, 20, 110),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forget Password?',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    TextFields(
                      label: 'EMAIL',
                      icon: Icon(Icons.email_outlined),
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            onPressed: (){
                              FirebaseAuth.instance.sendPasswordResetEmail(
                                  email: _emailController.text,
                              ).then((value) => {
                                Navigator.of(context).pop()
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('  RESET'),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_forward, size: 24.0)
                              ],)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "know Password?",
                style: TextStyle(
                    fontFamily: 'SFUIDisplay', color: Colors.black, fontSize: 15
                ),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SignIn()));
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      fontFamily: 'SFUIDisplay',
                      color: Colors.green,
                      fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFields extends StatelessWidget{
  final Icon icon;
  final String label;
  TextEditingController controller;
  bool secureText;

  TextFields({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.secureText = false
  });

  @override
  Widget build(BuildContext context){
    return Container(
      child: TextFormField(
        controller: controller,
        style: TextStyle(
            color: Colors.black, fontFamily: 'SFUIDisplay'
        ),
        decoration: InputDecoration(

          border: InputBorder.none,
          labelText: label,
          prefixIcon: icon,
          labelStyle: TextStyle(fontSize: 12),

        ),
      ),
    );
  }
}
