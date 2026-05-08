import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Home Screen',style: TextStyle(
          color: Colors.white,
          fontSize: 20
        ),),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}