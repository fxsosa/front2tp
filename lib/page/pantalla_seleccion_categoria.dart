import 'package:flutter/material.dart';
import 'package:front2tp/model/categoria.dart';
import 'package:front2tp/service/database.dart';

class PantallaSeleccionCategoria extends StatefulWidget {
  const PantallaSeleccionCategoria({super.key});

  @override
  _PantallaSeleccionCategoriaState createState() => _PantallaSeleccionCategoriaState();
}

class _PantallaSeleccionCategoriaState extends State<PantallaSeleccionCategoria> {
  List<Categoria> Categoriaes = [];
  List<Categoria> CategoriaesFiltrados = [];

  @override
  void initState() {
    super.initState();
    db.getAllCategorias().then((value) {
      setState(() {
      Categoriaes = value;
      CategoriaesFiltrados = value;
      });
    });
  }

  void _cargarCategorias(String nombre) async {
    Categoriaes = await db.getAllByNameCategoria(nombre);
    setState(() {
      CategoriaesFiltrados = Categoriaes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Categoria'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CategoriaSearch(Categoriaes, db.getAllCategorias),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: CategoriaesFiltrados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(CategoriaesFiltrados[index].descripcion),
            onTap: () {
              Navigator.pop(context, CategoriaesFiltrados[index]);
            },
          );
        },
      ),
    );
  }
}

class _CategoriaSearch extends SearchDelegate<Categoria> {
  final List<Categoria> categorias;
  final Function() onSearch;

  _CategoriaSearch(this.categorias, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          onSearch();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Utiliza Navigator.pop para regresar sin hacer una selección
        Navigator.pop(context);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch();
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categorias[index].descripcion),
          onTap: () {
            close(context, categorias[index]);
          },
        );
      },
    );
  }
}
