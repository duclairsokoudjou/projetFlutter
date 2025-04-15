import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/home_screen.dart';
import 'package:login/sign_in.dart';

class SignUP extends StatefulWidget {
  const SignUP ({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // FormKey pour la validation

  // Méthode pour valider les champs
  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Le mot de passe est requis';
    } else if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  // Méthode pour valider l'email
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'L\'email est requis';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Méthode pour valider la confirmation du mot de passe
  String? _validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  // Méthode pour l'inscription de l'utilisateur
  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        // Afficher une erreur selon le type d'exception
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur: ${e.toString()}'),
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 110, 20, 110),
              child: Form(
                key: _formKey, // Utilisation du formulaire avec la validation
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    TextFields(
                      label: 'FULL NAME',
                      icon: Icon(Icons.person_2_outlined),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 10),
                    TextFields(
                      label: 'EMAIL',
                      icon: Icon(Icons.email_outlined),
                      controller: _emailController,
                      validator: _validateEmail, // Validation email
                    ),
                    const SizedBox(height: 10),
                    TextFields(
                      label: 'PASSWORD',
                      secureText: true,
                      icon: Icon(Icons.lock_outlined),
                      controller: _passwordController,
                      validator: _validatePassword, // Validation du mot de passe
                    ),
                    const SizedBox(height: 10),
                    TextFields(
                      label: 'CONFIRM PASSWORD',
                      secureText: true,
                      icon: Icon(Icons.lock_outlined),
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword, // Validation confirmation mot de passe
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _signUp, // Utilisation de la méthode d'inscription
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('  SIGN UP'),
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
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(
                  fontFamily: 'SFUIDisplay', color: Colors.black, fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                },
                child: Text(
                  'Sign In',
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

class TextFields extends StatelessWidget {
  final Icon icon;
  final String label;
  TextEditingController controller;
  bool secureText;
  final String? Function(String?)? validator;

  TextFields({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.secureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
        obscureText: secureText,
        validator: validator, // Ajout de la validation
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
