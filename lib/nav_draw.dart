import 'package:flutter/material.dart';
import 'package:front2tp/page/categoria_page.dart';
import 'package:front2tp/page/ficha_page.dart';
import 'package:front2tp/page/Persona_page.dart';
import 'package:front2tp/page/reserva_page.dart';

class NavigationDrawerCustom extends StatelessWidget {
  const NavigationDrawerCustom({key}) : super(key: key);
  @override
  Widget build(context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
  Widget buildHeader(context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );
  Widget buildMenuItems(context) => Column(children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Categoria'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CategoriaPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Pacientes/Doctores'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PersonaPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Reserva'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ReservaPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Ficha'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  FichaClinicaPage(),
              ),
            );
          },
        ),
      ]);
}
