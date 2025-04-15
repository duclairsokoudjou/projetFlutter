import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>(); // FormKey pour la validation des champs

  // Méthode pour valider l'email
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'L\'email est requis';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Méthode pour valider le mot de passe
  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Le mot de passe est requis';
    }
    return null;
  }

  // Méthode pour se connecter
  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailAddressController.text,
          password: _passwordController.text,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        // Afficher une erreur selon le type d'exception
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur : ${e.toString()}'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 110, 20, 110),
          child: Form(
            key: _formKey, // Utilisation du formulaire avec la validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please sign in to continue.',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                SizedBox(height: 40),
                // Champ de saisie pour l'email
                TextFormField(
                  controller: _emailAddressController,
                  style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                  validator: _validateEmail, // Validation de l'email
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'EMAIL',
                    prefixIcon: Icon(Icons.email_outlined),
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                // Champ de saisie pour le mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                  validator: _validatePassword, // Validation du mot de passe
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'PASSWORD',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgetPassword()),
                        );
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
                      onPressed: _signIn, // Appel de la méthode de connexion
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('  LOGIN'),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward, size: 24.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUP()),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay',
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
