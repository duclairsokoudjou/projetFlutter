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
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateName(User user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'New Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String password = _passwordController.text.trim();
                String newName = _nameController.text.trim();

                if (password.isEmpty || newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: password,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.updateDisplayName(newName);
                  await user.reload();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name updated successfully')),
                  );
                  setState(() {});
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(User user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.verified_user),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String currentPassword = _passwordController.text.trim();
                String newPassword = _newPasswordController.text.trim();
                String confirmPassword = _confirmPasswordController.text.trim();

                if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.updatePassword(newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/signin', 
        (route) => false
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteAccount(User user) async {
    try {
      await user.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/signup', 
        (route) => false
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'Please log in',
              style: TextStyle(fontSize: 24),
            ),
          );
        } else {
          User user = snapshot.data!;

          return CustomScaffold(
            showBottomNavBar: true,
            initialIndex: 2,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Vert
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.green[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'e-Commerce App',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Section Compte
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                'Account Settings',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildInfoRow(Icons.person, 'Name:', user.displayName ?? 'Not set'),
                              _buildInfoRow(Icons.email, 'Email:', user.email ?? 'Not set'),
                              const SizedBox(height: 30),
                              Column(
                                children: [
                                  _buildActionButton('Update Name', Icons.edit, Colors.green, () => _updateName(user)),
                                  const SizedBox(height: 15),
                                  _buildActionButton('Change Password', Icons.lock, Colors.green, () => _changePassword(user)),
                                  const SizedBox(height: 15),
                                  _buildActionButton('Logout', Icons.exit_to_app, Colors.grey, _logout),
                                  const SizedBox(height: 15),
                                  _buildActionButton('Delete Account', Icons.delete, Colors.red, () => _deleteAccount(user)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Historique des achats
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Text(
                                  'Purchase History',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                FutureBuilder<List<Purchase>>(
                                  future: PurchaseService.getPurchases(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text("Error: ${snapshot.error}"));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          "No purchases found",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, color: Colors.grey),
                                        ),
                                      );
                                    } else {
                                      final purchases = snapshot.data!;
                                      double totalAmount = purchases.fold(
                                        0, 
                                        (sum, item) => sum + (item.price * item.quantity)
                                      );
                                      int totalItems = purchases.fold(
                                        0, 
                                        (sum, item) => sum + item.quantity
                                      );

                                      return Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: purchases.length,
                                            itemBuilder: (context, index) {
                                              final purchase = purchases[index];
                                              return ListTile(
                                                leading: const Icon(Icons.shopping_cart, color: Colors.green),
                                                title: Text(purchase.productName),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Quantity: ${purchase.quantity}'),
                                                    Text(
                                                      DateFormat('dd/MM/yyyy - HH:mm').format(purchase.date),
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '\$${purchase.price.toStringAsFixed(2)}/u',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    Text(
                                                      '\$${(purchase.price * purchase.quantity).toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.green,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          const Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Total Items: $totalItems',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                Text(
                                                  'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}