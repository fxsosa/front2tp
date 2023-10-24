import 'package:flutter/material.dart';
import 'package:front2tp/nav_draw.dart';

class PacientesDoctoresPage extends StatefulWidget {
  const PacientesDoctoresPage({super.key});
  @override
  State<PacientesDoctoresPage> createState() {
    return _PacientesDoctoresPageState();
  }
}

class _PacientesDoctoresPageState extends State<PacientesDoctoresPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes/Doctoress'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
