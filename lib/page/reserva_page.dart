import 'package:flutter/material.dart';

class ReservaPage extends StatefulWidget {
  const ReservaPage({super.key});
  @override
  State<ReservaPage> createState() {
    return _ReservaPageState();
  }
}

class _ReservaPageState extends State<ReservaPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
