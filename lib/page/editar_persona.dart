import 'dart:core';
import 'dart:ffi';

import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/service/database.dart';
import 'package:flutter/material.dart';

class EditarPersona extends StatefulWidget {
  EditarPersona({super.key});

  @override
  State<EditarPersona> createState() => _EditarPersonaState();
}

class _EditarPersonaState extends State<EditarPersona> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();

  final apellidoController = TextEditingController();

  final telController = TextEditingController();

  final emailController = TextEditingController();

  final cedulaController = TextEditingController();

  String esDoctor = '';
  bool esDoctorBool = true;

  // cambiar por un dropdownButtonField
  List<DropdownMenuItem<String>> menuEsDoctor = const [
    DropdownMenuItem(
      value: "Doctor",
      child: Text("Doctor"),
    ),
    DropdownMenuItem(
      value: "Paciente",
      child: Text("Paciente"),
    ),
  ];

  cargarEsDoctor(newValue) async {
    setState(() {
      esDoctor = newValue;
      esDoctorBool = newValue == 'Doctor' ? true : false;
    });
  }

  @override
  Widget build(context) {
    Persona persona = ModalRoute.of(context)!.settings.arguments as Persona;
    nombreController.text = persona.nombre;
    apellidoController.text = persona.apellido;
    telController.text = persona.telefono;
    emailController.text = persona.email;
    cedulaController.text = persona.cedula;
    esDoctor = persona.flagEsDoctor ? 'Doctor' : 'Paciente';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guardar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre es obligatorio";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextFormField(
                controller: apellidoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El apellido es obligatorio";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Apellido"),
              ),
              TextFormField(
                controller: cedulaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La cedula es obligatoria";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Cedula"),
              ),
              TextFormField(
                controller: telController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El telefono es obligatorio";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Tel"),
              ),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El email es obligatorio";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Email"),
              ),
              DropdownButtonFormField(
                  items: menuEsDoctor,
                  value: esDoctor,
                  onChanged: (String? newValue) {
                    cargarEsDoctor(newValue);
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (persona.idPersona > 0) {
                        persona.nombre = nombreController.text;
                        persona.apellido = apellidoController.text;
                        persona.telefono = telController.text;
                        persona.email = emailController.text;
                        persona.cedula = cedulaController.text;
                        persona.flagEsDoctor = esDoctorBool;

                        db.updatePersona(persona);
                      } else {
                        db.insertPersona(Persona(
                          idPersona: persona.idPersona,
                          nombre: nombreController.text,
                          apellido: apellidoController.text,
                          telefono: telController.text,
                          email: emailController.text,
                          cedula: cedulaController.text,
                          flagEsDoctor: esDoctorBool,
                        ));
                      }
                      Navigator.pushNamed(context, "/persona");
                    }
                  },
                  child: const Text("Guardar"))
            ],
          ),
        ),
      ),
    );
  }
}
