
import 'package:flutter/material.dart';
import 'package:front2tp/model/categoria.dart';
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/model/reserva.dart';
import 'package:front2tp/page/pantalla_seleccion_categoria.dart';
import 'package:front2tp/page/pantalla_seleccion_doctor.dart';
import 'package:front2tp/page/pantalla_seleccion_paciente.dart';
import 'package:front2tp/service/database.dart';

class EditarReserva extends StatefulWidget {
  final Reserva reserva;

  const EditarReserva({super.key, required this.reserva});

  @override
  State<EditarReserva> createState() => _EditarReservaState();
}

class _EditarReservaState extends State<EditarReserva> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fechaController;
  late TextEditingController _horaInicioController;
  late TextEditingController _horaFinController;
  late TextEditingController _doctorController;
  late TextEditingController _pacienteController;
  late TextEditingController _categoriaController;

  late List<Persona> doctores;
  late List<Persona> pacientes;

  List<Persona> doctoresFiltrados = [];
  List<Persona> pacientesFiltrados = [];
  List<Categoria> categoriasFiltradas = [];

  String? doctorSeleccionado;
  String? pacienteSeleccionado;
  Categoria? categoriaSeleccionada;

  int _idDoctorSeleccionado = 0;
  int _idPacienteSeleccionado = 0;
  int _idCategoriaSeleccionada = 0;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(text: widget.reserva.fecha);
    _horaInicioController =
        TextEditingController(text: widget.reserva.horarioInicio);
    _horaFinController = TextEditingController(text: widget.reserva.horarioFin);
    _doctorController = TextEditingController(text: '');
    db.getOneByIdPersonaDeVerdad(widget.reserva.idDoctor).then((value) {
      _doctorController =
          TextEditingController(text: '${value.nombre} ${value.apellido}');
      _idDoctorSeleccionado = value.idPersona;
      setState(() {});
    }).catchError((error) {
      _doctorController = TextEditingController(text: '');
    });
    _pacienteController = TextEditingController(text: '');
    db.getOneByIdPersonaDeVerdad(widget.reserva.idPaciente).then((value) {
      _pacienteController =
          TextEditingController(text: '${value.nombre} ${value.apellido}');
      _idPacienteSeleccionado = value.idPersona;
      setState(() {});
    }).catchError((error) {
      _pacienteController = TextEditingController(text: '');
    });
    _categoriaController = TextEditingController(text: '');
    db.getOneByIdCategoriaDeVerdad(widget.reserva.idCategoria).then((value) {
      _categoriaController = TextEditingController(text: '${value.descripcion}');
      _idCategoriaSeleccionada = value.idCategoria;
      setState(() {});
    }).catchError((error) {
      _categoriaController = TextEditingController(text: '');
    });

    db.getAllDoctores().then((value) => doctores = value);
    db.getAllPacientes().then((value) => pacientes = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.reserva.idReserva == 0 ? 'Crear Reserva' : 'Editar Reserva'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una fecha';
                  }
                  return null;
                },
                onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                    ).then((value) {
                      if (value != null) {
                        _fechaController.text =
                            value.toString().substring(0, 10);
                      }
                    })),
            TextFormField(
                controller: _horaInicioController,
                decoration: const InputDecoration(labelText: 'Hora Inicio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una hora de inicio';
                  } else if (!value.substring(3, 5).contains("00") ||
                      int.parse(value.substring(0, 2)) < 07 ||
                      int.parse(value.substring(0, 2)) > 21) {
                    return 'Por favor ingrese una hora de inicio valida.';
                  }
                  return null;
                },
                onTap: () => showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          DateTime.parse("20120227 08:00:00")),
                    ).then((value) {
                      if (value != null) {
                        _horaInicioController.text =
                            value.toString().substring(10, 15);
                      }
                    })),
            TextFormField(
              controller: _doctorController,
              decoration: const InputDecoration(labelText: 'Doctor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un doctor';
                }
                return null;
              },
              onTap: () => _navegarYSeleccionarDoctor(context),
            ),
            // Hacer lo mismo que el TextFormField de doctor pero con paciente
            TextFormField(
              controller: _pacienteController,
              decoration: const InputDecoration(labelText: 'Paciente'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un paciente';
                }
                return null;
              },
              onTap: () => _navegarYSeleccionarPaciente(context),
            ),

            // Hacer lo mismo que el TextFormField de doctor pero con categoria
            TextFormField(
              controller: _categoriaController,
              decoration: const InputDecoration(labelText: 'Categoria'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una categoria';
                }
                return null;
              },
              onTap: () => _navegarYSeleccionarCategoria(context),
            ),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _guardarReserva();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

/*
  Future<void> _seleccionarDoctor(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Doctor'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    db.getAllByNameDoctor(value).then((value) {
                      setState(() {
                        doctoresFiltrados = value;
                      });
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: doctoresFiltrados.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(doctoresFiltrados[index].nombre),
                        onTap: () {
                          setState(() {
                            doctorSeleccionado = doctoresFiltrados[index].idPersona.toString();
                            // Actualiza la reserva con el doctor seleccionado
                            widget.reserva.idDoctor = doctoresFiltrados[index].idPersona;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          ),
        );
      },
    );
  }*/

  void _navegarYSeleccionarDoctor(BuildContext context) async {
    final Persona? doctorSeleccionado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaSeleccionDoctor(),
      ),
    );

    if (doctorSeleccionado != null) {
      setState(() {
        _doctorController.text =
            '${doctorSeleccionado.nombre} ${doctorSeleccionado.apellido}';
        _idDoctorSeleccionado = doctorSeleccionado.idPersona;
      });
    }
  }

  void _navegarYSeleccionarPaciente(BuildContext context) async {
    final Persona? pacienteSeleccionado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaSeleccionPaciente(),
      ),
    );

    if (pacienteSeleccionado != null) {
      setState(() {
        _pacienteController.text =
            '${pacienteSeleccionado.nombre} ${pacienteSeleccionado.apellido}';
        _idPacienteSeleccionado = pacienteSeleccionado.idPersona;
      });
    }
  }

  void _navegarYSeleccionarCategoria(BuildContext context) async {
    final Categoria? categoriaSeleccionada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaSeleccionCategoria(),
      ),
    );

    if (categoriaSeleccionada != null) {
      setState(() {
        _categoriaController.text = '${categoriaSeleccionada.descripcion}';
        _idCategoriaSeleccionada = categoriaSeleccionada.idCategoria;
      });
    }
  }

  void _guardarReserva() async {
    widget.reserva.fecha = _fechaController.text;
    widget.reserva.horarioInicio = _horaInicioController.text;
    widget.reserva.horarioFin =
        (int.parse(_horaInicioController.text.substring(0, 2)) + 1).toString() +
            _horaInicioController.text.substring(2, 5);
    widget.reserva.idDoctor = _idDoctorSeleccionado;
    widget.reserva.idPaciente = _idPacienteSeleccionado;
    widget.reserva.idCategoria = _idCategoriaSeleccionada;
    // Lógica para guardar o actualizar la reserva en la base de datos
    await db.guardarReserva(widget.reserva);
    Navigator.pop(_formKey.currentContext!);
  }
}
