import 'dart:convert';

class PhotoItem {
  final String imagePath;
  final String name;
  final String category; // For shirt/outer/accessory/pants
  final String season; // To decide the degree 
  PhotoItem(this.imagePath, this.name, this.category, this.season);

  factory PhotoItem.fromJson(Map<String, dynamic> json) => PhotoItem (json['imagePath'], json['name'], json['category'], json['season']);

  Map<String, dynamic> toJson() => {'imagePath': imagePath, 'name':name, 'category':category, 'season': season};
}

