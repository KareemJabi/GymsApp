import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => bottomnavigation(
                      index: 0,
                    ))));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => bottomnavigation(index: 0),
            ));
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: const Image(
            image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpKAYzo9pTG-XBQFk0ga3mfjRP49kAPXVkSQ&usqp=CAU'),
            fit: BoxFit.fill),
      ),
    ));
  }
}
