import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite'),
        backgroundColor: const Color.fromARGB(255, 9, 56, 95),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text('Favourite'),
        ),
      ),
    );
  }
}
