import 'package:flutter/material.dart';
import 'package:front2tp/model/ficha.dart'; // Asegúrate de cambiar la ruta del import según tu estructura
import 'package:front2tp/page/editar_ficha.dart';
import 'package:front2tp/service/database.dart'; // Asegúrate de cambiar la ruta del import según tu estructura

class FichaClinicaPage extends StatefulWidget {
  @override
  _FichaClinicaPageState createState() => _FichaClinicaPageState();
}

class _FichaClinicaPageState extends State<FichaClinicaPage> {
  List<FichaClinica> fichas = [];

  @override
  void initState() {
    super.initState();
    _loadFichas();
  }

  Future<void> _loadFichas() async {
    final fichasDb = await db
        .getAllFichasClinicas(); // Asegúrate de que este método esté definido en tu servicio de base de datos
    setState(() {
      fichas = fichasDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fichas Clínicas'),
      ),
      body: ListView.builder(
        itemCount: fichas.length,
        itemBuilder: (context, index) {
          final ficha = fichas[index];
          return FutureBuilder(
            future: Future.wait([
              db.getOneByIdPersonaDeVerdad(ficha.idPaciente),
              db.getOneByIdPersonaDeVerdad(ficha.idDoctor),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text('Cargando...'),
                );
              }
              if (snapshot.hasError) {
                return ListTile(
                  title: Text('Error al cargar los datos'),
                );
              }
              final paciente = snapshot.data?[0];
              final doctor = snapshot.data?[1];
              return ListTile(
                title: Text('Ficha de $paciente'),
                subtitle:
                    Text('Doctor: $doctor - Fecha: ${ficha.fecha.toString()}'),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditFichaClinicaPage(ficha: ficha),
                    ),
                  );
                  _loadFichas();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => EditFichaClinicaPage(
                        ficha: FichaClinica(
                      idFicha: 0,
                      idPaciente: 0,
                      idDoctor: 0,
                      idCategoria: 0,
                      fecha: DateTime.now().toIso8601String(),
                      motivoConsulta: '',
                      diagnostico: '',
                    ))),
          );
          _loadFichas();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
