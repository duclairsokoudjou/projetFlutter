import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/forget_password.dart';
import 'package:login/home_screen.dart';
import 'package:login/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn ({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 110, 20, 110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
              ),
        ),
              SizedBox(height: 10),
              Text(
                'Please sign in to continue.',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            SizedBox(height: 40),
            TextFormField(
              controller: _emailAddressController,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'SFUIDisplay'
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'EMAIL',
                prefixIcon: Icon(Icons.email_outlined),
                labelStyle: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: true ,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFUIDisplay'
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'PASSWORD',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                    },
                    child: Text(
                      'FORGOT',
                      style: TextStyle(color: Colors.green),
                    ),
                ),
                labelStyle: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: (){
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailAddressController.text,
                        password: _passwordController.text,
                      ).then((value) => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder:(context) => HomeScreen()
                        ))
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('  LOGIN'),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, size: 24.0)
                      ],
                    )
                ),
              ),
            ),

            SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: BorderSide(color: Colors.grey),
                  ),
                  icon: Image.asset('images/google.jpeg'),
                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontFamily: 'SFUIDisplay',
                color: Colors.black,
                fontSize: 15
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder:(context) => SignUP()
                  ));
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay',
                    color: Colors.green,
                    fontSize: 15
                  ),
                )
            )
          ],
        ),
      ),
    ),
    );
  }
}
