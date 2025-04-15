import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login/purchase_service.dart';
import 'package:login/purchase.dart';
import 'custom_scaffold.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!; // Récupérer l'utilisateur actuellement connecté
    _nameController = TextEditingController(text: _user.displayName); // Initialiser avec le nom actuel
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fonction pour mettre à jour le nom de l'utilisateur
  void _updateName() async {
    try {
      await _user.updateDisplayName(_nameController.text);
      await _user.reload();
      _user = _auth.currentUser!;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom mis à jour avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  // Fonction pour mettre à jour le mot de passe
  void _updatePassword() async {
    try {
      await _user.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  // Fonction pour supprimer le compte
  void _deleteAccount() async {
    try {
      await _user.delete();
      Navigator.of(context).pop(); // Retourner à l'écran précédent après suppression
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte supprimé avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return CustomScaffold(
      showBottomNavBar: true,
      initialIndex: 2, // Onglet "Account" sélectionné
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: screenWidth,
                decoration: BoxDecoration(color: Colors.green[700]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
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
                        _user.email ?? '', // Affichage de l'email actuel
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                'images/account.jpeg',
                height: 150,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'My Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${_user.displayName ?? 'Nom non défini'}', // Affichage du nom
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${_user.email}', // Affichage de l'email
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour se déconnecter
                        _auth.signOut();
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: const Text('Logout'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Modifier le nom de l'utilisateur
                        _updateName();
                      },
                      child: const Text('Update Name'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Modifier le mot de passe de l'utilisateur
                        _updatePassword();
                      },
                      child: const Text('Change Password'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Supprimer le compte de l'utilisateur
                        _deleteAccount();
                      },
                      child: const Text('Delete Account'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Purchase History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              FutureBuilder<List<Purchase>>(
                future: PurchaseService.getPurchases(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur : ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Tu n'as pas encore effectué d'achat.",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    );
                  } else {
                    List<Purchase> purchases = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: purchases.length,
                      itemBuilder: (context, index) {
                        final purchase = purchases[index];

                        // Calcul du total pour chaque article (prix * quantité)
                        double itemTotal = purchase.price * purchase.quantity;

                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(purchase.productName),
                            subtitle: Text(
                              'Prix: \$${purchase.price} x ${purchase.quantity} = \$${itemTotal.toStringAsFixed(2)}', // Affichage du total de l'article
                            ),
                            trailing: Text(DateFormat.yMMMd().format(purchase.date)),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
