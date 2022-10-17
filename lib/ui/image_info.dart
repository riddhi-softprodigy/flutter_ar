import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

// show augmented image
class AugmentedImage extends StatefulWidget {
  final String? imagePath;
  AugmentedImage({this.imagePath});
  @override
  _ImageInfoState createState() => _ImageInfoState();
}

class _ImageInfoState extends State<AugmentedImage> {
  ArCoreController? arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image 3D View'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    // _addSphere(arCoreController!);
    // _addCylindre(arCoreController!);
    _addCube(arCoreController!);
  }

  Future _addSphere(ArCoreController controller) async {
    final ByteData textureBytes = await rootBundle.load(widget.imagePath!);

    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylindre,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
  }

  void _addCylindre(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylindre,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
  }

  Future<void> _addCube(ArCoreController controller) async {
    final ByteData textureBytes = await rootBundle.load(widget.imagePath!);
    final material = ArCoreMaterial(
      metallic: 0,
      reflectance: 0.6,
      roughness: 0,
      color: Colors.transparent,

      // textureBytes: textureBytes.buffer.asUint8List()
    );
    final cube = ArCoreImage(
        bytes: textureBytes.buffer.asUint8List(), height: 600, width: 600);
    ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.9, 0.9, 0.9),
    );
    final node = ArCoreNode(
      image: cube,
      // shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );

    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController!.dispose();
    super.dispose();
  }
}
