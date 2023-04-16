//Packages Used
import 'package:flutter/material.dart';

//Local files used
import './widget/enable_location.dart';

//Used to launch the application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnableLocation(),
    );
  }
}
