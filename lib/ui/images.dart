import 'package:ar_app/ui/image_info.dart';
import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<String> images = [
    'assets/chair1.jpg',
    'assets/chair3.jpg',
    'assets/chair4.jpg',
    'assets/chair5.jpg',
    'assets/chair6.jpg',
    'assets/chair7.jpg',
    'assets/chair8.jpg'
  ];
  Widget content(String imagePath) => Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      borderOnForeground: true,
      shadowColor: Colors.grey,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AugmentedImage(
                imagePath: imagePath,
              ),
            ),
          );
        },
        child: Container(
            margin: EdgeInsets.all(10),
            height: 150,
            child: Image.asset(imagePath)),
      ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Images'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: images.map<Widget>((e) => content(e)).toList(),
          ),
        ));
  }
}
