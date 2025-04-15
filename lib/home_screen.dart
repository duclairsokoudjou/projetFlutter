import 'package:flutter/material.dart';
import 'package:login/cart_provider.dart';
import 'package:login/product_detail.dart';
import 'package:provider/provider.dart';
import 'custom_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardItem> cardItems = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    cardItems = [
      CardItem(title: 'Shirt 1', price: 10.0, images: ['images/1.jpeg', 'images/2.jpeg']),
      CardItem(title: 'Shirt 2', price: 20.0, images: ['images/2.jpeg', 'images/1.jpeg']),
      CardItem(title: 'Shirt 3', price: 30.0, images: ['images/3.jpeg', 'images/1.jpeg']),
      CardItem(title: 'Shirt 4', price: 40.0, images: ['images/4.jpeg', 'images/2.jpeg']),
      CardItem(title: 'Shirt 5', price: 50.0, images: ['images/5.jpeg', 'images/2.jpeg']),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = cardItems
        .where((item) => item.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        showBottomNavBar: true,
        initialIndex: 0,
        body: SafeArea(
          child: Column(
            children: [
              // Barre de recherche améliorée
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Rechercher...',
                    prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.green[700]),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) => setState(() => searchText = value),
                ),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 50, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun produit trouvé',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : GridView.count(
                        padding: const EdgeInsets.all(16),
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: filteredItems.map((cardItem) => _buildProductCard(cardItem, context)).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(CardItem cardItem, BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItem = cartProvider.cartitems.firstWhere(
      (item) => item.name == cardItem.title,
      orElse: () => CartItem(name: cardItem.title, price: cardItem.price, quantity: 0),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetail(
            name: cardItem.title,
            price: cardItem.price,
            images: cardItem.images,
          ),
        ),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Section image améliorée
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: cardItem.images.length,
                    onPageChanged: (index) => setState(() => cardItem.currentIndex = index),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        cardItem.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        cardItem.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == cardItem.currentIndex ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == cardItem.currentIndex 
                                ? Colors.green[700]
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Contenu de la carte
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardItem.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '\$${cardItem.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildCartControls(cartItem, cartProvider),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartControls(CartItem cartItem, CartProvider cartProvider) {
    return cartItem.quantity > 0
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 20, color: Colors.green[700]),
                onPressed: () {
                  if (cartItem.quantity > 1) {
                    cartProvider.updateQuantity(cartItem.name, cartItem.quantity - 1);
                  } else {
                    cartProvider.removeByName(cartItem.name);
                  }
                },
              ),
              Text('${cartItem.quantity}', style: TextStyle(color: Colors.green[700])),
              IconButton(
                icon: Icon(Icons.add, size: 20, color: Colors.green[700]),
                onPressed: () => cartProvider.updateQuantity(cartItem.name, cartItem.quantity + 1),
              ),
            ],
          )
        : IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Colors.green[700]),
            onPressed: () => cartProvider.addToCart(CartItem(
              name: cartItem.name,
              price: cartItem.price,
              quantity: 1,
            )),
          );
  }
}

class CardItem {
  final String title;
  final double price;
  final List<String> images;
  int currentIndex;

  CardItem({
    required this.title,
    required this.price,
    required this.images,
    this.currentIndex = 0,
  });
}