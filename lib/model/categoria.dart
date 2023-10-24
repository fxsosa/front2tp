class Categoria {
  int idCategoria;
  String descripcion;

  Categoria({required this.idCategoria, required this.descripcion});

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      idCategoria: map['idCategoria'],
      descripcion: map['descripcion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'descripcion': descripcion,
    };
  }
}
