
import 'package:cloud_firestore/cloud_firestore.dart';

class Furniture {
  final int furnitureId;
  final double price;
  final String size;
  final double rating;
  final String category;
  final String furnitureName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Furniture(
      {required this.furnitureId,
      required this.price,
      required this.category,
      required this.furnitureName,
      required this.size,
      required this.rating,
      required this.imageURL,
      required this.isFavorated,
      required this.decription,
      required this.isSelected});

  factory Furniture.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return Furniture(
      furnitureId: data?['furnitureId'] ?? 0,
      price: data?['price'] ?? 0,
      category: data?['category'] ?? 'default',
      furnitureName: data?['name'] ?? '',
      size: data?['size'] ?? '',
      rating: data?['rating'] ?? 0.0,
      imageURL: data?['image_url'] ?? '',
      isFavorated: data?['isFavorated'] ?? false,
      decription: data?['description'] ?? '',
      isSelected: data?['isSelected'] ?? false,
    );
  }

  //List of Plants data
  static List<Furniture> furnitureList = [
    Furniture(
        furnitureId: 0,
        price: 22,
        category: 'Indoor',
        furnitureName: 'Sanseviera',
        size: 'Small',
        rating: 4.5,
        imageURL: 'assets/images/furni1.jpeg',
        isFavorated: true,
        decription:
            'This Furniture is one of the best Furniture.'
            'even the harshest weather condition.',
        isSelected: false),
    Furniture(
        furnitureId: 1,
        price: 11,
        category: 'Outdoor',
        furnitureName: 'Philodendron',
        size: 'Medium',
        rating: 4.8,
        imageURL: 'assets/images/furni2.jpeg',
        isFavorated: false,
        decription:
            'This Furniture is one of the best Furniture.'
            'even the harshest weather condition.',
        isSelected: false),
    Furniture(
        furnitureId: 2,
        price: 18,
        category: 'Indoor',
        furnitureName: 'Beach Daisy',
        size: 'Large',
        rating: 4.7,
        imageURL: 'assets/images/furni3.jpeg',
        isFavorated: false,
        decription:
            'This Furniture is one of the best Furniture.'
            'even the harshest weather condition.',
        isSelected: false),
    Furniture(
        furnitureId: 3,
        price: 30,
        category: 'Outdoor',
        furnitureName: 'Big Bluestem',
        size: 'Small',
        rating: 4.5,
        imageURL: 'assets/images/furni3.jpeg',
        isFavorated: false,
        decription:
            'This Furniture is one of the best Furniture.'
            'even the harshest weather condition.',
        isSelected: false),


    Furniture(
        furnitureId: 6,
        price: 19,
        category: 'Garden',
        furnitureName: 'Plumbago',
        size: 'Small',
        rating: 4.2,
        imageURL: 'assets/images/furni4.jpeg',
        isFavorated: false,
        decription:
            'This Furniture is one of the best Furniture.'
            'even the harshest weather condition.',
        isSelected: false),
    Furniture(
        furnitureId: 7,
        price: 23,
        category: 'Garden',
        furnitureName: 'Tritonia',
        size: 'Medium',
        rating: 4.5,
        imageURL: 'assets/images/furni5.jpeg',
        isFavorated: false,
        decription:
            'This Furniture is one of the best Furniture.'
            'even the harshest weather condition.',
        isSelected: false),
    Furniture(
        furnitureId: 8,
        price: 46,
        category: 'Recommended',
        furnitureName: 'Tritonia',
        size: 'Medium',
        rating: 4.7,
        imageURL: 'assets/images/furni1.jpeg',
        isFavorated: false,
        decription:
            'This Furniture is one of the best Furniture. '
            'even the harshest weather condition.',
        isSelected: false),
  ];

  //Get the favorated items
  static List<Furniture> getFavoritedFurnitures() {
    List<Furniture> _travelList = Furniture.furnitureList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Furniture> addedToCartFurnitures() {
    List<Furniture> _selectedFurnitures = Furniture.furnitureList;
    return _selectedFurnitures
        .where((element) => element.isSelected == true)
        .toList();
  }
}
