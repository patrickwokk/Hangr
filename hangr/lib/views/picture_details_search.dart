import 'package:flutter/material.dart';
import 'dart:io';

class PictureDetailsSearch extends StatelessWidget {
  final String imagePath;
  final String name;
  final String category;
  final String season;
  const PictureDetailsSearch({this.imagePath, this.name, this.category, this.season});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              child: Image.asset(imagePath),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                category,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                season,
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}