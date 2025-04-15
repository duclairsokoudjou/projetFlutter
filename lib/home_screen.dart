import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login/bottom_nav_bar.dart';
import 'package:login/product_detail.dart';

import 'custom_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen ({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<CardItem> cardItems = [];

=======
  String searchtext = '';

  @override
  void initState(){
    super.initState();
    cardItems = [
      CardItem(title: 'Shirt 1', pricing: '\$10', images:['images/1.jpeg', 'images/2.jpeg', 'images/2.jpeg']),
      CardItem(title: 'Shirt 2', pricing: '\$20', images:['images/2.jpeg', 'images/1.jpeg', 'images/4.jpeg']),
      CardItem(title: 'Shirt 3', pricing: '\$30', images:['images/3.jpeg', 'images/1.jpeg', 'images/5.jpeg']),
      CardItem(title: 'Shirt 4', pricing: '\$40', images:['images/4.jpeg', 'images/2.jpeg', 'images/3.jpeg']),
      CardItem(title: 'Shirt 5', pricing: '\$50', images:['images/5.jpeg', 'images/2.jpeg', 'images/4.jpeg']),
    ];
  }


  @override
  Widget build(BuildContext context) {

    
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) { 
          currentFocus.focusedChild?.unfocus();
      }},
    
     child : CustomScaffold(
      body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.green[700]),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search restaurants, cuisines & dishes',
                              hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                              border: InputBorder.none,
                              icon : Icon(Icons.search),
                            ),
                            onChanged: (value){
                              setState(() {
                                searchText = value;
                              });
                            },
                          )
                      ),
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.filter_list)
                      ),
                    ],

                  ),
      
                ),


              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: cardItems.where((cardItem) => cardItem.title.toLowerCase().contains(searchText.toLowerCase()) ).map((cardItem){ return buildCard(cardItem)}).toList()

                ),
              )
            ],
          )
      ),
      showBottomNavBar: true,
      initialIndex: 0,
    ));

  }

  Widget buildCard(CardItem cardItem){
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductDetail())
        );
      },
      child: Card(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: PageView.builder(
                itemCount: cardItem.images.length,
                  onPageChanged: (int index){
                    setState(() {
                      cardItem.currentIndex == index;
                    });
                  },
                  itemBuilder: (context, index){
                    return Image.asset(
                      cardItem.images[index],
                      fit: BoxFit.cover,
                    );
                  },
              ),
            ),
            Row(
              children: List<Widget>.generate(cardItem.images.length,
                (int circleIndex){
                return Padding(
                  padding: EdgeInsets.all(4.0),
                  child: CircleAvatar(
      radius: 4,
      backgroundColor: circleIndex == cardItem.currentIndex ? Colors.blue : Colors.grey,
      ),
                );
            })
            ),
            ListTile(
              title: Text(
                cardItem.title,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(cardItem.pricing),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text('Premium',
                style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardItem{
  final String title;
  final String pricing;
  final List<String> images;
  int currentIndex;

  CardItem(
      {required this.title,
        required this.pricing,
        required this.images,
        this.currentIndex = 0

      });
}
