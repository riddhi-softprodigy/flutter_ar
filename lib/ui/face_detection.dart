import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

// show face filters
class AugmentedFacesScreen extends StatefulWidget {
  const AugmentedFacesScreen({Key? key}) : super(key: key);

  @override
  _AugmentedFacesScreenState createState() => _AugmentedFacesScreenState();
}

class _AugmentedFacesScreenState extends State<AugmentedFacesScreen> {
  ArCoreFaceController? arCoreFaceController;
  ArCoreNode? leftEye;
  ArCoreNode? rightEye;
  String? objectSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          ArCoreFaceView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableAugmentedFaces: true,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ListObjectSelection(
              onTap: (value) {
                objectSelected = value;

                loadMesh();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;

    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes =
        await rootBundle.load('assets/$objectSelected.png');

    arCoreFaceController!.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: '$objectSelected.sfb');
  }

  @override
  void dispose() {
    arCoreFaceController!.dispose();
    super.dispose();
  }
}

class ListObjectSelection extends StatefulWidget {
  final Function? onTap;

  ListObjectSelection({this.onTap});

  @override
  _ListObjectSelectionState createState() => _ListObjectSelectionState();
}

class _ListObjectSelectionState extends State<ListObjectSelection> {
  List<String> masks = ['fox_face_mesh_texture', 'mask', 'dot'];

  String? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        itemCount: masks.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = masks[index];
                widget.onTap!(masks[index]);
              });
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 5,
                      color: selected == masks[index]
                          ? Colors.blueAccent
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                padding: selected == masks[index] ? EdgeInsets.all(8.0) : null,
                child: Image.asset("assets/" + masks[index] + ".png"),
              ),
            ),
          );
        },
      ),
    );
  }
}
