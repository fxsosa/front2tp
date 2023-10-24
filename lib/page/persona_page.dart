import 'package:flutter/material.dart';
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/service/database.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({super.key});
  @override
  State<PersonaPage> createState() {
    return _PersonaPageState();
  }
}

class _PersonaPageState extends State<PersonaPage> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pacientes/Doctoress'),
          backgroundColor: Colors.red,
          // Copiar desde aca
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/editarPersona",
                arguments: Persona(
                  idPersona: 0,
                  nombre: "",
                  apellido: "",
                  telefono: "",
                  email: '',
                  cedula: '',
                  flagEsDoctor: true,
                ));
          },
          child: const Icon(Icons.add),
        ),
        body: const ListaPersonas());
  }
}

// reemplazar ListaPersonas por otro
class ListaPersonas extends StatefulWidget {
  const ListaPersonas({super.key});
  @override
  State<ListaPersonas> createState() {
    return _ListaPersonasState();
  }
}

// reemplazar ListaPersonas
class _ListaPersonasState extends State<ListaPersonas> {
  // reemplazar nombre lista
  List<Persona> personas = [];
  @override
  void initState() {
    cargarListaPersonas();
    super.initState();
  }

  cargarListaPersonas() async {
    List<Persona> auxPersonas = await db.getAllPersonas();
    setState(() {
      personas = auxPersonas;
    });
  }

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: personas.length,
      itemBuilder: (context, i) => Dismissible(
        key: Key(i.toString()),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(left: 5),
          child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.delete, color: Colors.white)),
        ),
        onDismissed: (direction) {
          db.deletePersona(personas[i]);
        },
        child: ListTile(
          title: Text(personas[i].toString()),
          subtitle: Text(personas[i].descripcionPersona()),
          trailing: MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, "/editarPersona",
                  arguments: personas[i]);
            },
            child: const Icon(
              Icons.edit,
            ),
          ),
        ),
      ),
    );
  }
}
