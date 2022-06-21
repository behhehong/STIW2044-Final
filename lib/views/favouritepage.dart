import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favourite'),
          backgroundColor: const Color.fromARGB(255, 9, 56, 95),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Favourite'),
        ),
      ),
    );
  }
}
