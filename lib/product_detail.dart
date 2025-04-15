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
    setState(() {
      selectedButton = buttonIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              onPageChanged: (index, _) {
                setState(() => _currentSlide = index);
              },
            ),
            items: widget.images.map((image) {
              return Builder(
                builder: (context) => Image.asset(image, fit: BoxFit.cover),
              );
            }).toList(),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text('Price: \$${widget.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              'Product Description',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('* This is an amazing shirt', style: TextStyle(fontSize: 16)),
                Text('* Very comfortable and stylish', style: TextStyle(fontSize: 16)),
                Text('* Perfect for any occasion', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      selectButton(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == 1 ? Colors.green : Colors.white,
                    ),
                    child: Text(
                      'RESELL',
                      style: TextStyle(
                        color: selectedButton == 1 ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      selectButton(2);
                      addToCart();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == 2 ? Colors.green : Colors.white,
                    ),
                    child: Text(
                      'ADD TO CART',
                      style: TextStyle(
                        color: selectedButton == 2 ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
