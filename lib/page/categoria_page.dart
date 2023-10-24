import 'package:flutter/material.dart';
import 'package:front2tp/model/categoria.dart';
import 'package:front2tp/service/database.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});
  @override
  State<CategoriaPage> createState() {
    return _CategoriaPageState();
  }
}

class _CategoriaPageState extends State<CategoriaPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/editarCategoria",
              arguments: Categoria(
                idCategoria: 0,
                descripcion: "",
              ));
        },
      ),
      body: const ListaCategoria(),
    );
  }
}

class ListaCategoria extends StatefulWidget {
  const ListaCategoria({super.key});
  @override
  State<ListaCategoria> createState() {
    return _ListaCategoriaState();
  }
}

class _ListaCategoriaState extends State<ListaCategoria> {
  List<Categoria> categorias = [];
  @override
  void initState() {
    cargaListaCategoria();
    super.initState();
  }

  cargaListaCategoria() async {
    List<Categoria> auxCategoria = await db.getAllCategorias();

    setState(() {
      categorias = auxCategoria;
    });
  }

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: categorias.length,
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
          db.deleteCategoria(categorias[i]);
        },
        child: ListTile(
          title: Text(categorias[i].descripcion),
          trailing: MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, "/editarCategoria",
                  arguments: categorias[i]);
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
