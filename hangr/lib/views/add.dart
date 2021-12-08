import 'dart:developer';
import 'dart:io';
import 'package:hangr/controller/controller.dart';
import 'package:hangr/models/models_picture.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:hangr/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class AddPicture extends StatefulWidget {
  const AddPicture({
    Key key,
  }) : super(key: key);

  @override
  State<AddPicture> createState() => _AddPictureState();
  
}


class _AddPictureState extends State<AddPicture> {
  File image;
  String dropdownCategoryValue = 'Accessories';
  String dropdownSeasonValue = 'Spring';

  Future PickImage(ImageSource source) async{
    try {
      final XFile imagePick = await (ImagePicker().pickImage(source: source,imageQuality: 50));
      if (imagePick == null) return;
      
      final imageTemp = File(imagePick.path);
      print(imagePick.path.runtimeType);
      // final imagePermanent = await saveImagePermanently(imagePick.path);
      setState(() { image = imageTemp;});
      } on PlatformException catch (e) {
        print("Fail to pick image");
      }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.08),      
            image != null 
            ? Image.file(image, width: 160, height: 160, fit: BoxFit.cover,) 
            : Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/png/imageplaceholder.png'),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                  _showPicker(context);
                  nameController.clear();
                },
              child: const Text("Add Image",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    // fontFamily: 'SF',
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
      
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 10,
                          spreadRadius: 4,
                          offset: Offset(0.0, 8.0)),
                          // color: Color.fromRGBO(17, 111, 255, 0.2),
                          // blurRadius: 20.0,
                          // offset: Offset(0, 10))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade100))),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ),
          
                    //------------------------------------------------------
                    //Category
                    //------------------------------------------------------
                    DropdownButton<String>(
                        value: dropdownCategoryValue,
                        icon: const Icon(Icons.arrow_downward_outlined),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownCategoryValue = newValue;
                            print(dropdownCategoryValue);
                          });
                        },
                        items: <String>['Accessories', 'Outer', 'Shirts', 'Pants', 'Shoes']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                  //------------------------------------------------------
                  //Season
                  //------------------------------------------------------
                    DropdownButton<String>(
                      value: dropdownSeasonValue,
                      icon: const Icon(Icons.arrow_downward_outlined),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownSeasonValue = newValue;
                          print(dropdownSeasonValue);
                        });
                      },
                      items: <String>['Spring', 'Summer', 'Fall', 'Winter']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            SizedBox(
              width: size.width * 0.4,
              height: size.height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    splashFactory: NoSplash.splashFactory,
                    primary: Colors.amber, // background
                    onPrimary: Colors.white, // foreground
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)))),
                onPressed: () {
                  _sharedPref();
                  Navigator.pushNamed(context, '/homepage');
                },
                child: const Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ),
          ],
          
        ),
      )
    );
  }

  _sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     List<PhotoItem> _items = [];
    final String savedItemsJson = prefs.getString('items'); // read

    if (savedItemsJson == null){
      _items = [];
      
    }
    else{
      final List<dynamic> itemsDeserialized = json.decode(savedItemsJson); //decode
      _items = itemsDeserialized.map((json) => PhotoItem.fromJson(json)).toList(); // part of decode (mapping process)
      print(_items);
      
    }
    _items.add(PhotoItem(image.path, nameController.text, dropdownCategoryValue, dropdownSeasonValue));
    
    
    final String _itemsJson = json.encode(_items.map((e) => e.toJson()).toList()); //encode
    prefs.setString('items', _itemsJson); // write

    
  }

  //show modal bottom sheet
  void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      PickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    PickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}



