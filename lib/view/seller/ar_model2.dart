import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
class ArScreentwo extends StatelessWidget {
  ArScreentwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Model Viewer')),
      body: const ModelViewer(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/patio_chair_reconstruction.glb',
        alt: 'A 3D model of an patio_chair_reconstruction',
        ar: true,
        autoRotate: true,
        iosSrc: 'assets/patio_chair_reconstruction.glb',
        disableZoom: true,
      ),
    );
  }
}