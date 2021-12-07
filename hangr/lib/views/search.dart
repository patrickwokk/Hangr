import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hangr/models/models_picture.dart';
import 'package:hangr/views/picture_details.dart';
import 'package:hangr/views/picture_details_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({ Key key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<PhotoItem> _items = [
  PhotoItem("assets/png/beanie.png", "Beanie", "Accessories", "Fall"),
  PhotoItem("assets/png/chain.png", "Silver Chain", "Accessories", "Summer"),
  PhotoItem("assets/png/coat.png", "Black Coat", "Outer", "Winter"),
  PhotoItem("assets/png/glove.png", "Leather Glove","Accessories", "Winter"),
  PhotoItem("assets/png/hat.png", "Bucket Hat", "Accessories", "Spring"),
  PhotoItem("assets/png/jeans.png", "Straight Jeans", "Pants", "Summer"),
  PhotoItem("assets/png/outer.png", "White Jacket", "Outer", "Spring"),
  PhotoItem("assets/png/pants.png", "slack", "Pants", "Fall"),
  PhotoItem("assets/png/scarf.png", "Blue Scarf", "Accessories", "Spring"),
  PhotoItem("assets/png/shirtlong.png", "Long Shirt", "Shirts", "Summer"),
  PhotoItem("assets/png/shoes.png", "Dress Shoes", "Shoes", "Fall"),
  PhotoItem("assets/png/shortpants.jpg", "Running Shorts", "Pants", "Summer"),
  PhotoItem("assets/png/sneaker.png", "Zara Sneaker", "Shoes", "Summer"),
  PhotoItem("assets/png/suit.png", "Navy Blue suit", "Outer", "Fall"),
  PhotoItem("assets/png/sunglasses.png", "Sunglasses", "Accessories", "Summer"),
  PhotoItem("assets/png/sweater.png", "Sweater", "Outer", "Spring"),
  PhotoItem("assets/png/sweatpants.png", "Sweatpants", "Pants", "Winter"),
  PhotoItem("assets/png/tshirt.png", "Blach T-shirt", "Shirts", "Summer"),
  PhotoItem("assets/png/turtleneck.png", "Turtleneck", "Shirts", "Winter"),
  PhotoItem("assets/png/watch.jpg", "JLC watch", "Accessories", "Fall"),
  PhotoItem("assets/png/whiteshirt.png", "White T-shirt", "Shirts", "Summer"),
  ]; 

  @override
  initState() {
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
                  builder: (context) => PictureDetailsSearch(
                      imagePath: _items[index].imagePath, 
                      name: _items[index].name, 
                      category:_items[index].category, 
                      season: _items[index].season,),
                ),
              );
            },
            child: Container(
             decoration: BoxDecoration(
               image: DecorationImage(
                 fit: BoxFit.cover,
                 image: AssetImage(_items[index].imagePath),
               ),
              ),
            ),
          );
        },
      ),
    );
  }
}