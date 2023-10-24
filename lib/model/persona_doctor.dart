class Persona {
  int idPersona;
  String nombre;
  String apellido;
  String? telefono;
  String? email;
  String cedula;
  bool flagEsDoctor;

  Persona({
    required this.idPersona,
    required this.nombre,
    required this.apellido,
    this.telefono,
    this.email,
    required this.cedula,
    required this.flagEsDoctor,
  });

  factory Persona.fromMap(Map<String, dynamic> map) {
    return Persona(
      idPersona: map['idPersona'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      telefono: map['telefono'],
      email: map['email'],
      cedula: map['cedula'],
      flagEsDoctor:
          map['flag_es_doctor'] == 1, // Convierte el valor booleano a entero
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPersona': idPersona,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
      'cedula': cedula,
      'flag_es_doctor':
          flagEsDoctor ? 1 : 0, // Convierte el valor booleano a entero
    };
  }
}
