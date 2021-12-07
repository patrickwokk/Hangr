import 'package:flutter/material.dart';

import 'dart:io';

class Camera extends StatefulWidget {
  const Camera({
    Key key,
  }) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  String firstButtonText = 'Take photo';
  


  @override
  Widget build(BuildContext context) {
    return Text(
      'Index 1: Camera',
    );
  }
}

