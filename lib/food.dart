import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';
import 'custom_scaffold.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  // Variables existantes
  final List<String> imagePaths = [
    'images/1.jpeg',
    'images/2.jpeg',
    'images/3.jpeg',
    'images/4.jpeg',
    'images/5.jpeg',
  ];

  final List<String> titles = ['Shirt 1', 'Shirt 2', 'Shirt 3', 'Shirt 4', 'Shirt 5'];
  final List<String> ratings = ['4.5', '4.2', '4.8', '4.0', '4.3'];
  final List<String> subtitles = ['Classic Fit', 'Slim Fit', 'Premium Cotton', 'Designer Edition', 'Summer Collection'];
 final List<String> pricing = ['\$10', '\$20', '\$30', '\$40', '\$50'];

  // Nouveaux états pour la recherche
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filtrage dynamique
  List<int> get _filteredIndices {
    return List.generate(titles.length, (index) => index)
        .where((index) => titles[index].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProductReviews(int index) {
    // ... [Le code existant de _showProductReviews reste inchangé] ...
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barre de recherche avec filtre dynamique
            Container(
              height: 80,
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
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Rechercher un produit...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close, color: Colors.green[700]),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            // Grille filtrée
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: _filteredIndices.length,
                itemBuilder: (context, gridIndex) {
                  final index = _filteredIndices[gridIndex];
                  return GestureDetector(
                    onTap: () => _showProductReviews(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.asset(
                              imagePaths[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titles[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitles[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 16),
                                          Text(
                                            ' ${ratings[index]}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green[700],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          pricing[index],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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