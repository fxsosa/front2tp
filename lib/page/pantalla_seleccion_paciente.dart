import 'package:flutter/material.dart';
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/service/database.dart';

class PantallaSeleccionPaciente extends StatefulWidget {
  const PantallaSeleccionPaciente({super.key});

  @override
  _PantallaSeleccionPacienteState createState() => _PantallaSeleccionPacienteState();
}

class _PantallaSeleccionPacienteState extends State<PantallaSeleccionPaciente> {
  List<Persona> Pacientes = [];
  List<Persona> PacientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    db.getAllPacientes().then((value) {
      setState(() {
      Pacientes = value;
      PacientesFiltrados = value;
      });
    });
  }

  void _cargarPacientes(String nombre) async {
    Pacientes = await db.getAllByNamePaciente(nombre);
    setState(() {
      PacientesFiltrados = Pacientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Paciente'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _PacienteSearch(Pacientes, db.getAllPacientes),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: PacientesFiltrados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(PacientesFiltrados[index].nombre),
            onTap: () {
              Navigator.pop(context, PacientesFiltrados[index]);
            },
          );
        },
      ),
    );
  }
}

class _PacienteSearch extends SearchDelegate<Persona> {
  final List<Persona> Pacientes;
  final Function() onSearch;

  _PacienteSearch(this.Pacientes, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          onSearch();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Utiliza Navigator.pop para regresar sin hacer una selección
        Navigator.pop(context);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch();
    return ListView.builder(
      itemCount: Pacientes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(Pacientes[index].nombre),
          onTap: () {
            close(context, Pacientes[index]);
          },
        );
      },
    );
  }
}
