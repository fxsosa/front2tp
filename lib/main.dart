import 'package:flutter/material.dart';
import 'package:front2tp/page/categoria_page.dart';
import 'package:front2tp/page/editar_categoria.dart';
import 'package:front2tp/page/editar_persona.dart';
import 'package:front2tp/page/home_page.dart';
import 'package:front2tp/page/Persona_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Front 2P',
      initialRoute: '/',
      // Aqui se agregan las rutas de cada seccion de la app
      routes: {
        '/': (context) => const MyHomePage(),
        '/categoria': (context) => const CategoriaPage(),
        '/editarCategoria': (context) => EditarCategoria(),
        '/persona': (context) => const PersonaPage(),
        '/editarPersona': (context) => EditarPersona(),
      },
    );
  }
}
