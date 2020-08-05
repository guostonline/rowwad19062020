import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rowwad/Pages/SplachScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplachScreen(),
    ));
  });
}
