import 'package:flutter/material.dart';
import 'package:login/cart_provider.dart';
import 'package:login/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:login/purchase_service.dart';
import 'package:login/purchase.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<String> images = [
    'images/1.jpeg',
    'images/2.jpeg',
    'images/3.jpeg',
    'images/4.jpeg',
    'images/5.jpeg'
  ];

  double getCartTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.quantity * item.price);
  }

void processCheckout(List<CartItem> cartItems) async {
  final DateTime now = DateTime.now();
  final String orderId = now.toIso8601String(); // Utilisation d'un ID unique pour la commande

  List<Purchase> purchasesToAdd = [];

  for (var item in cartItems) {
    Purchase purchase = Purchase(
      productName: item.name,
      price: item.price,
      date: now,  // La même date pour tous les produits de la même commande
      quantity: item.quantity,
      purchaseId: orderId,  // Le même ID pour toute la commande
    );

    purchasesToAdd.add(purchase);  // Ajouter chaque achat à une liste temporaire
  }

  // Après avoir collecté tous les achats, ajoutons-les tous à SharedPreferences
  for (var purchase in purchasesToAdd) {
    await PurchaseService.addPurchase(purchase);  // Enregistrer chaque achat
  }
}





  void showCheckoutDialog(List<CartItem> cartItems) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: const Text('You have purchased the products!'),
        actions: [
          TextButton(
            onPressed: () {
              processCheckout(cartItems);
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem> cartItems = Provider.of<CartProvider>(context).cartitems;

    return CustomScaffold(
      showBottomNavBar: true,
      initialIndex: 1, // Tab Cart actif
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.green[700]),
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Cart',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All the products you have added!',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        "Votre panier est vide.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        CartItem item = cartItems[index];
                        return Dismissible(
                          key: Key(item.name),
                          onDismissed: (_) {
                            Provider.of<CartProvider>(context, listen: false).removeFromCart(item);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            child: ListTile(
                              leading: Image.asset(
                                images[index % images.length],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item.name),
                              subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 1) item.quantity--;
                                      });
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(item.quantity.toString(), style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (cartItems.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Text('Cart Total:', style: TextStyle(fontSize: 18)),
                    const Spacer(),
                    Text(
                      '\$${getCartTotal(cartItems).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showCheckoutDialog(cartItems),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
