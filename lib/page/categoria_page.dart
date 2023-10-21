import 'package:flutter/material.dart';
import 'package:front2tp/nav_draw.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});
  @override
  State<CategoriaPage> createState() {
    return _CategoriaPageState();
  }
}

class _CategoriaPageState extends State<CategoriaPage> {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        backgroundColor: Colors.green,
      ),
      drawer: const NavigationDrawerCustom(),
    );
  }
}
