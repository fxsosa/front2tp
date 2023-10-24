import 'dart:core';

import 'package:front2tp/model/categoria.dart';
import 'package:front2tp/service/database.dart';
import 'package:flutter/material.dart';

class EditarCategoria extends StatelessWidget {
  EditarCategoria({super.key});
  final _formKey = GlobalKey<FormState>();
  final descripcionController = TextEditingController();

  @override
  Widget build(context) {
    Categoria categoria =
        ModalRoute.of(context)!.settings.arguments as Categoria;
    descripcionController.text = categoria.descripcion;

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
                controller: descripcionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La descripcion es obligatoria";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Descripcion"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (categoria.idCategoria > 0) {
                        categoria.descripcion = descripcionController.text;
                        db.updateCategoria(categoria);
                      } else {
                        db.insertCategoria(
                          Categoria(
                              idCategoria: categoria.idCategoria,
                              descripcion: descripcionController.text),
                        );
                      }
                      Navigator.pushNamed(context, "/categoria");
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
