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

  // Données des avis
  final List<List<Map<String, dynamic>>> _productReviews = [
    [
      {'user': 'Jean D.', 'comment': 'Très confortable', 'stars': 4, 'date': '15/03/2024'},
      {'user': 'Marie L.', 'comment': 'Taille parfaite', 'stars': 5, 'date': '12/03/2024'},
    ],
    [
      {'user': 'Pierre R.', 'comment': 'Matériau de qualité', 'stars': 4, 'date': '10/03/2024'},
    ],
    [
      {'user': 'Sophie M.', 'comment': 'Livraison rapide', 'stars': 5, 'date': '08/03/2024'},
    ],
    [
      {'user': 'Luc T.', 'comment': 'Un peu cher', 'stars': 3, 'date': '05/03/2024'},
    ],
    [
      {'user': 'Emma B.', 'comment': 'Parfait pour l\'été', 'stars': 4, 'date': '01/03/2024'},
    ],
  ];

  // Filtrage dynamique
  List<int> get _filteredIndices {
    return List.generate(titles.length, (index) => index)
        .where((index) => titles[index].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _showProductReviews(int index) {
    final originalIndex = _filteredIndices[index];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              titles[originalIndex],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber[600], size: 20),
                const SizedBox(width: 4),
                Text(
                  '${ratings[originalIndex]} (${_productReviews[originalIndex].length} avis)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _productReviews[originalIndex].length,
                separatorBuilder: (context, index) => const Divider(height: 30),
                itemBuilder: (context, reviewIndex) {
                  final review = _productReviews[originalIndex][reviewIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.person, color: Colors.green[700]),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            review['user'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ...List.generate(5, (starIndex) => Icon(
                            Icons.star,
                            size: 18,
                            color: starIndex < review['stars'] 
                                ? Colors.amber[600] 
                                : Colors.grey[300],
                          )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          review['comment'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          review['date'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barre de recherche
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
                    hintText: 'Search reviews...',
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
            
            // Grille des produits
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
                  final originalIndex = _filteredIndices[gridIndex];
                  return GestureDetector(
                    onTap: () => _showProductReviews(gridIndex),
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
                              imagePaths[originalIndex],
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
                                    titles[originalIndex],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitles[originalIndex],
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
                                            ' ${ratings[originalIndex]}',
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
                                          pricing[originalIndex],
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