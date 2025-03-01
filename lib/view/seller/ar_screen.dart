import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
class ArScreenone extends StatelessWidget {
  ArScreenone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Model Viewer')),
      body: const ModelViewer(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/old_chair.glb',
        alt: 'A 3D model of an astronaut',
        ar: true,
        autoRotate: true,
        iosSrc: 'assets/old_chair.glb',
        disableZoom: true,
      ),
    );
  }
}