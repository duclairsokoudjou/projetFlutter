import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:login/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final String name;
  final double price;
  final List<String> images;

  const ProductDetail({
    super.key,
    required this.name,
    required this.price,
    required this.images,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _currentSlide = 0;
  int selectedButton = 2;

  void addToCart() {
    CartItem newItem = CartItem(name: widget.name, price: widget.price, quantity: 1);
    final provider = Provider.of<CartProvider>(context, listen: false);
    
    final index = provider.cartitems.indexWhere((item) => item.name == newItem.name);
    if (index != -1) {
      provider.cartitems[index].quantity++;
    } else {
      provider.addToCart(newItem);
    }
    provider.notifyListeners();
  }

  void selectButton(int buttonIndex) {
    setState(() => selectedButton = buttonIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isInCart = Provider.of<CartProvider>(context).cartitems.any((item) => item.name == widget.name);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Carrousel amélioré
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, _) => setState(() => _currentSlide = index),
                ),
                items: widget.images.map((image) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                )).toList(),
              ),
              Positioned(
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.images.asMap().entries.map((entry) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _currentSlide == entry.key ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentSlide == entry.key 
                            ? Colors.green[700]
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          
          // Section informations
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${widget.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Description améliorée
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ce produit haut de gamme allie confort et style. Parfait pour toutes occasions, '
                  'il offre une coupe moderne et une durabilité exceptionnelle.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton d'action amélioré
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  isInCart ? Icons.check_circle : Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: Text(
                  isInCart ? 'Déjà dans le panier' : 'Ajouter au panier',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? Colors.grey : Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: isInCart ? null : () {
                  selectButton(2);
                  addToCart();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}