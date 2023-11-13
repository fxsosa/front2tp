
import 'package:flutter/material.dart';
import 'package:front2tp/model/categoria.dart';
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/model/reserva.dart';
import 'package:front2tp/page/editar_reserva.dart';
import 'package:front2tp/service/database.dart';

class ReservaPage extends StatefulWidget {
  const ReservaPage({super.key});

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  List<Reserva> reservas = [];
  List<Persona> doctoresFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarReservas();
  }

  void _cargarReservas() async {
    reservas = await db.obtenerReservas(); // Método a ser definido en database.dart
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
      ),
      body: ListView.builder(
        itemCount: reservas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: FutureBuilder(
              future: db.getOneByIdCategoriaDeVerdad(reservas[index].idCategoria),
              builder: (BuildContext context, AsyncSnapshot<Categoria> snapshot) {
                if (snapshot.hasData) {
                  return Text('Reserva: ${snapshot.data?.descripcion}');
                } else {
                  return const Text('Cargando...');
                }
              },
            ),
            subtitle: FutureBuilder <List<Persona>>(
              future: Future.wait([db.getOneByIdPersonaDeVerdad(reservas[index].idPaciente), db.getOneByIdPersonaDeVerdad(reservas[index].idDoctor)]),
              builder: (BuildContext context, AsyncSnapshot<List<Persona>> snapshot) {
                if (snapshot.hasData) {
                  return Text('Paciente: ${snapshot.data![0].nombre} ${snapshot.data![0].apellido} - Doctor: ${snapshot.data![1].nombre} ${snapshot.data![1].apellido}');
                } else {
                  return const Text('Cargando...');
                }
              },
            ), 
            
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditarReserva(reserva: reservas[index])),
              );
              _cargarReservas();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Aquí se maneja la acción para añadir una nueva reserva
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarReserva(
              reserva: Reserva(
                // Inicializa los valores según sea necesario
                idReserva: 0, // Un valor que indique que es una nueva reserva
                idPaciente: 0,
                idDoctor: 0,
                fecha: '',
                horarioInicio: '',
                horarioFin: '',
                cancelado: false,
                idCategoria: 0,
              ),
            ),
          ),
        );
      },
      tooltip: 'Añadir Reserva',
      child: Icon(Icons.add), // Icono de '+'
    ),
    );
  }

  

}
