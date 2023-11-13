import 'package:flutter/material.dart';
import 'package:front2tp/model/persona_doctor.dart'; // Asegúrate de que este importe es correcto
import 'package:front2tp/service/database.dart'; // Asegúrate de que este importe es correcto

class PersonaPage extends StatefulWidget {
  const PersonaPage({super.key});
  @override
  State<PersonaPage> createState() {
    return _PersonaPageState();
  }
}

class _PersonaPageState extends State<PersonaPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  String personaType = 'all'; // 'all', 'patient', 'doctor'

  final GlobalKey<_ListaPersonasState> listaPersonasKey = GlobalKey();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes/Doctores'),
        backgroundColor: Colors.red,
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
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: ListaPersonas(
              key: listaPersonasKey,
              nameFilter: _nameController.text,
              surnameFilter: _surnameController.text,
              personaType: personaType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        TextField(
          controller: _surnameController,
          decoration: const InputDecoration(labelText: 'Apellido'),
        ),
        DropdownButton<String>(
          value: personaType,
          onChanged: (String? newValue) {
            setState(() {
              personaType = newValue!;
            });
          },
          items: const <String>['all', 'patient', 'doctor']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              listaPersonasKey.currentState?.cargarListaPersonas();
            });
          },
          child: const Text('Aplicar Filtro'),
        ),
      ],
    );
  }
}


// reemplazar ListaPersonas por otro
class ListaPersonas extends StatefulWidget {
  final String nameFilter;
  final String surnameFilter;
  final String personaType;

  const ListaPersonas({
    Key? key,
    required this.nameFilter,
    required this.surnameFilter,
    required this.personaType,
  }): super(key: key);

  @override
  State<ListaPersonas> createState() => _ListaPersonasState();
}

class _ListaPersonasState extends State<ListaPersonas> {
  List<Persona> personas = [];

  @override
  void initState() {
    super.initState();
    cargarListaPersonas();
  }

  cargarListaPersonas() async {
    // Ajusta esta función para que use los filtros
    List<Persona> auxPersonas = await db.getFilteredPersonas(
      widget.nameFilter,
      widget.surnameFilter,
      widget.personaType,
    );
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
            child: const Icon(Icons.edit),
          ),
        ),
      ),
    );
  }
}

