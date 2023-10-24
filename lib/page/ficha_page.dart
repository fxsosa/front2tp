import 'package:flutter/material.dart';

class FichaPage extends StatefulWidget {
  const FichaPage({super.key});
  @override
  State<FichaPage> createState() {
    return _FichaPageState();
  }
}

class _FichaPageState extends State<FichaPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fichas'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
