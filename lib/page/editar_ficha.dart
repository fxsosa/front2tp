import 'package:flutter/material.dart';
import 'package:front2tp/model/categoria.dart';
import 'package:front2tp/model/ficha.dart'; // Asegúrate de cambiar la ruta del import según tu estructura
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/page/pantalla_seleccion_categoria.dart';
import 'package:front2tp/page/pantalla_seleccion_doctor.dart';
import 'package:front2tp/page/pantalla_seleccion_paciente.dart';
import 'package:front2tp/service/database.dart';
import 'package:intl/intl.dart'; // Asegúrate de cambiar la ruta del import según tu estructura

class EditFichaClinicaPage extends StatefulWidget {
  final FichaClinica? ficha;

  const EditFichaClinicaPage({Key? key, this.ficha}) : super(key: key);

  @override
  _EditFichaClinicaPageState createState() => _EditFichaClinicaPageState();
}

class _EditFichaClinicaPageState extends State<EditFichaClinicaPage> {
  final _formKey = GlobalKey<FormState>();
  late int idPaciente;
  late int idDoctor;
  late int idCategoria;
  late DateTime fecha;
  late String motivoConsulta;
  late String diagnostico;
  late TextEditingController _pacienteController;
  late TextEditingController _doctorController;
  late TextEditingController _categoriaController;

  String? doctorSeleccionado;
  String? pacienteSeleccionado;
  Categoria? categoriaSeleccionada;

  int _idDoctorSeleccionado = 0;
  int _idPacienteSeleccionado = 0;
  int _idCategoriaSeleccionada = 0;

  @override
  void initState() {
    super.initState();

    _pacienteController = TextEditingController(text: '');
    db.getOneByIdPersonaDeVerdad(widget.ficha!.idPaciente).then((value) {
      _pacienteController =
          TextEditingController(text: '${value.nombre} ${value.apellido}');
      _idPacienteSeleccionado = value.idPersona;
      setState(() {});
    }).catchError((error) {
      _pacienteController = TextEditingController(text: '');
    });
    _doctorController = TextEditingController(text: '');
    db.getOneByIdPersonaDeVerdad(widget.ficha!.idDoctor).then((value) {
      _doctorController =
          TextEditingController(text: '${value.nombre} ${value.apellido}');
      _idDoctorSeleccionado = value.idPersona;
      setState(() {});
    }).catchError((error) {
      _doctorController = TextEditingController(text: '');
    });
    _categoriaController = TextEditingController(text: '');
    db.getOneByIdCategoriaDeVerdad(widget.ficha!.idCategoria).then((value) {
      _categoriaController = TextEditingController(text: '${value.descripcion}');
      _idCategoriaSeleccionada = value.idCategoria;
      setState(() {});
    }).catchError((error) {
      _categoriaController = TextEditingController(text: '');
    });

    if (widget.ficha != null) {
      // Si estamos editando una ficha existente, carga sus datos
      idPaciente = widget.ficha!.idPaciente;
      idDoctor = widget.ficha!.idDoctor;
      idCategoria = widget.ficha!.idCategoria;
      fecha = DateTime.parse(widget.ficha!.fecha.replaceAll(
          RegExp(r"(\d{2})/(\d{2})/(\d{4})"), r"$3-$2-$1T00:00:00"));
      motivoConsulta = widget.ficha!.motivoConsulta;
      motivoConsulta = widget.ficha!.motivoConsulta;
      diagnostico = widget.ficha!.diagnostico;
    } else {
      // Si estamos creando una nueva ficha, inicializa con valores por defecto
      idPaciente = 0; // Cambia esto según tu lógica de negocio
      idDoctor = 0; // Cambia esto según tu lógica de negocio
      idCategoria = 0; // Cambia esto según tu lógica de negocio
      fecha = DateTime.now();
      motivoConsulta = '';
      diagnostico = '';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final ficha = FichaClinica(
        idFicha: widget.ficha?.idFicha ??
            0, // Si es una nueva ficha, se supone que el ID es generado automáticamente por la base de datos
        idPaciente: _idPacienteSeleccionado,
        idDoctor: _idDoctorSeleccionado,
        idCategoria: _idCategoriaSeleccionada,
        fecha: fecha.toIso8601String(),
        motivoConsulta: motivoConsulta,
        diagnostico: diagnostico,
      );
      db.guardarFicha(ficha).then((value) => setState((){}));
      // Aquí puedes llamar a tu servicio de base de datos para insertar o actualizar la ficha
      Navigator.pop(context); // Regresa a la pantalla anterior una vez guardado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ficha == null
            ? 'Agregar Ficha Clínica'
            : 'Editar Ficha Clínica'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
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
            // Crea el TextFormField de doctor de la misma forma de la de paciente
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
            TextFormField(
              initialValue: motivoConsulta,
              decoration: InputDecoration(
                labelText: 'Motivo de la Consulta',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El motivo de la consulta es obligatorio';
                }
                return null;
              },
              onSaved: (value) {
                motivoConsulta = value!;
              },
            ),
            TextFormField(
              initialValue: diagnostico,
              decoration: InputDecoration(
                labelText: 'Diagnóstico',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El diagnóstico es obligatorio';
                }
                return null;
              },
              onSaved: (value) {
                diagnostico = value!;
              },
            ),
            ElevatedButton(
              onPressed: _saveForm,
              child: Text('Guardar Ficha Clínica'),
            ),
          ],
        ),
      ),
    );
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
  void _navegarYSeleccionarCategoria(BuildContext context) async {
    final Categoria? categoriaSeleccionada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaSeleccionCategoria(),
      ),
    );

    if (categoriaSeleccionada != null) {
      setState(() {
        _categoriaController.text =
            '${categoriaSeleccionada.descripcion}';
        _idCategoriaSeleccionada = categoriaSeleccionada.idCategoria;
      });
    }
  }
}
