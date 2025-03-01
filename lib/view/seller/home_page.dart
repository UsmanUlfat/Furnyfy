import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/Favorite.dart';
import '../../utils/constants.dart';
import '../../widgets/Furniturewidgets.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Furniture Shop'),
        centerTitle: true,
      ),
      body: FurnitureList(),
    );
  }
}

class FurnitureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('furniture').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Furniture> furnitureList =
            snapshot.data!.docs.map((QueryDocumentSnapshot doc) {
          return Furniture.fromSnapshot(doc);
        }).toList(); // Explicitly cast the list to 'List<Furniture>'

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      width: MediaQuery.of(context).size.width * .9,
                      // ignore: sort_child_properties_last
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.black54.withOpacity(.6),
                          ),
                          const Expanded(
                            child: TextField(
                              showCursor: false,
                              decoration: InputDecoration(
                                hintText: 'Search Furniture',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.mic,
                            color: Colors.black54.withOpacity(.6),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Constants.primaryColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      Set<String>.from(furnitureList.map((furniture) => furniture.category))
                          .length,
                  itemBuilder: (BuildContext context, int index) {
                    String category = Set<String>.from(
                        furnitureList.map((furniture) => furniture.category))
                        .toList()[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Handle category selection
                          if (kDebugMode) {
                            print('Selected category: $category');
                          }
                          // Implement your logic here
                        },
                        child: Text(
                          category, // Display category names
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                child: ListView.builder(
                  itemCount: furnitureList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child:
                                DetailPage( furniture: furnitureList[index],),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        // ignore: sort_child_properties_last
                        child: Stack(
                          children: [

                            Positioned(
                              left: 50,
                              right: 50,
                              top: 50,
                              bottom: 50,
                              child: Image.network(
                                furnitureList[index].imageURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                            //Favorite button
                            Positioned(
                              top: 10,
                              right: 20,
                              child: Container(
                                height: 50,
                                width: 50,
                                // ignore: sort_child_properties_last
                                child: IconButton(
                                  onPressed: () {
                                    // Handle favorite button toggle
                                  },
                                  icon: Icon(
                                    furnitureList[index].isFavorated
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Constants.primaryColor,
                                  ),
                                  iconSize: 30,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            // Plant details
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    furnitureList[index].category,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    furnitureList[index].furnitureName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Price
                            Positioned(
                              bottom: 15,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '\$${furnitureList[index].price.toString()}',
                                  style: TextStyle(
                                      color: Constants.primaryColor,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Constants.primaryColor.withOpacity(.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
                child: const Text(
                  'New Furniture',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: MediaQuery.of(context).size.height * .5,
                child: ListView.builder(
                  itemCount: furnitureList.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child:
                                DetailPage(furniture: furnitureList[index]),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      child: FurnitureWidget(index: index, furnitureList: furnitureList),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
