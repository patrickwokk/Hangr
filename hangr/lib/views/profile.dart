import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hangr/controller/controller.dart';
import 'package:hangr/models/models_picture.dart';
import 'package:hangr/views/picture_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<PhotoItem> _items = [];

  @override
  initState() {
    decodePref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 3,
          // childAspectRatio: 0.5,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PictureDetails(
                      imagePath: _items[index].imagePath, 
                      name: _items[index].name, 
                      category:_items[index].category, 
                      season: _items[index].season,),
                ),
              );
            },
            child: Container(
              child: Image.file(File(_items[index].imagePath)),
             // decoration: BoxDecoration(
               // image: DecorationImage(
                 // fit: BoxFit.cover,
                  //image: Image.file(new File(_items[index].imagePath))
                 // image: AssetImage(_items[index].imagePath),
               // ),
              //),
            ),
          );
        },
      ),
    );
  }
  decodePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedItemsJson = prefs.getString('items'); // read

    final List<dynamic> itemsDeserialized = json.decode(savedItemsJson); //decode
    setState(() {
        _items = itemsDeserialized.map((json) => PhotoItem.fromJson(json)).toList(); // part of decode (mapping process)
    });
  
    print(_items);
  }

}