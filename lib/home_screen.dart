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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        showBottomNavBar: true,
        initialIndex: 0,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.green[700]),
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text('No items found!'))
                    : GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        children: filteredItems.map((cardItem) => buildCard(cardItem, context)).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(CardItem cardItem, BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItem = cartProvider.cartitems.firstWhere(
      (item) => item.name == cardItem.title,
      orElse: () => CartItem(name: cardItem.title, price: cardItem.price, quantity: 0),
    );

    bool isInCart = cartItem.quantity > 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetail(
              name: cardItem.title,
              price: cardItem.price,
              images: cardItem.images,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: PageView.builder(
                itemCount: cardItem.images.length,
                onPageChanged: (index) {
                  setState(() {
                    cardItem.currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      cardItem.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cardItem.images.length,
                (circleIndex) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: circleIndex == cardItem.currentIndex ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(cardItem.title, style: const TextStyle(color: Colors.black)),
              subtitle: Text('\$${cardItem.price.toStringAsFixed(2)}'),
              trailing: isInCart
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (cartItem.quantity > 1) {
                              cartProvider.updateQuantity(cartItem.name, cartItem.quantity - 1);
                            } else {
                              cartProvider.removeByName(cartItem.name);
                            }
                          },
                        ),
                        Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartProvider.updateQuantity(cartItem.name, cartItem.quantity + 1);
                          },
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        cartProvider.addToCart(CartItem(
                          name: cardItem.title,
                          price: cardItem.price,
                          quantity: 1,
                        ));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Add'),
                    ),
            ),
          ],
        ),
      ),
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
