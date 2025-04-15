import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';
import 'custom_scaffold.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  List<String> imageUrls = [];
  List<String> titles = ['Spaghettis', 'Pizza', 'Burger', 'Fries', 'Salad'];
  List<String> ratings = ['4.5', '4.2', '4.8', '4.0', '4.3'];
  List<String> subtitles = ['Italian', 'Cheesy Goodness', 'Juicy & Tasty', 'Crispy Delight', 'Healthy Bowl'];
  List<String> pricing = ['\$10', '\$12', '\$8', '\$5', '\$7'];

  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      for (int i = 1; i <= titles.length; i++) {
        Reference ref = storage.ref().child('f$i.jpeg');
        String downloadUrl = await ref.getDownloadURL();
        setState(() {
          imageUrls.add(downloadUrl);
        });
      }
    } catch (e) {
      debugPrint("Error fetching images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.green[700]),
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
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
              child: imageUrls.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              image: NetworkImage(imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titles[index],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitles[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ratings[index] + " ★",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.amberAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        pricing[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      showBottomNavBar: true,
      initialIndex: 1,
    );
  }
}
