import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login/purchase_service.dart';
import 'package:login/purchase.dart';
import 'custom_scaffold.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

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
                child: const Padding(
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
                    const Text('Name: John Doe', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Email: duclairsokoudjou@gmail.com', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour se déconnecter
                      },
                      child: const Text('Logout'),
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
                      child: Text(
                        "Tu n'as pas encore effectué d'achat.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    );
                  } else {
                    List<Purchase> purchases = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: purchases.length,
                      itemBuilder: (context, index) {
                        final purchase = purchases[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('${purchase.productName} (${purchase.quantity}x)'),
                            subtitle: Text('Total: \$${(purchase.price * purchase.quantity).toStringAsFixed(2)}'),
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
