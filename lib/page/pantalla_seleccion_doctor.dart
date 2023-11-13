import 'package:flutter/material.dart';
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/service/database.dart';

class PantallaSeleccionDoctor extends StatefulWidget {
  const PantallaSeleccionDoctor({super.key});

  @override
  _PantallaSeleccionDoctorState createState() => _PantallaSeleccionDoctorState();
}

class _PantallaSeleccionDoctorState extends State<PantallaSeleccionDoctor> {
  List<Persona> doctores = [];
  List<Persona> doctoresFiltrados = [];

  @override
  void initState() {
    super.initState();
    db.getAllDoctores().then((value) {
      setState(() {
      doctores = value;
      doctoresFiltrados = value;
      });
    });
  }

  void _cargarDoctores(String nombre) async {
    doctores = await db.getAllByNameDoctor(nombre);
    setState(() {
      doctoresFiltrados = doctores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Doctor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _DoctorSearch(doctores, _cargarDoctores),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: doctoresFiltrados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(doctoresFiltrados[index].nombre),
            onTap: () {
              Navigator.pop(context, doctoresFiltrados[index]);
            },
          );
        },
      ),
    );
  }
}

class _DoctorSearch extends SearchDelegate<Persona> {
  final List<Persona> doctores;
  final Function(String dato) onSearch;

  _DoctorSearch(this.doctores, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          db.getAllDoctores();
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
    Navigator.pop(context);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch(query);
    return ListView.builder(
      itemCount: doctores.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(doctores[index].nombre),
          onTap: () {
            close(context, doctores[index]);
          },
        );
      },
    );
  }
}
