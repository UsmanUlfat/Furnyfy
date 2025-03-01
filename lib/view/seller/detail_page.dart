import 'package:furniy_ar/utils/app_size.dart';
import 'package:furniy_ar/view/seller/order_screen.dart';
import 'package:flutter/material.dart';
import '../../model/Favorite.dart';
import '../../utils/constants.dart';
import 'package:camera/camera.dart';

import 'camera_view.dart';

class CameraScreen extends StatelessWidget {
  final CameraController cameraController;

  const CameraScreen(this.cameraController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera View'),
      ),
      body: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }
}
class DetailPage extends StatefulWidget {
  final Furniture furniture;
  const DetailPage({Key? key, required this.furniture}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool toggleIsFavorated(bool isFavorited) => !isFavorited;
  bool toggleIsSelected(bool isSelected) => !isSelected;
  bool showARView = false;

  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    cameraController = CameraController(camera, ResolutionPreset.medium);
    await cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Constants.primaryColor),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.furniture.isFavorated =
                          toggleIsFavorated(widget.furniture.isFavorated);
                    });
                  },
                  icon: Icon(
                    widget.furniture.isFavorated
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Constants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Image.network(widget.furniture.imageURL, height: 350),

              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(.4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.furniture.furnitureName,
                      style: TextStyle(fontSize: 30)),
                  Text('\$${widget.furniture.price}',
                      style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  Text(widget.furniture.decription),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.furniture.isSelected =
                    toggleIsSelected(widget.furniture.isSelected);
              });
            },
            icon: Icon(
              Icons.shopping_cart,
              color: widget.furniture.isSelected
                  ? Colors.white
                  : Constants.primaryColor,
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderScreen(FurnitureId: widget.furniture.furnitureId.toString())),
                );
              },
              child: const Text('BUY NOW'),
            ),
          ),
        ],
      ),
    );
  }
}
