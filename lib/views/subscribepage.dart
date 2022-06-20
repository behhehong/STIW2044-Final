import 'package:flutter/material.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({Key? key}) : super(key: key);

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe'),
        backgroundColor: const Color.fromARGB(255, 9, 56, 95),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text('Subscribe'),
        ),
      ),
    );
  }
}
