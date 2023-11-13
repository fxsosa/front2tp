  class Persona {
    int idPersona;
    String nombre;
    String apellido;
    String telefono;
    String email;
    String cedula;
    bool flagEsDoctor;

    Persona({
      required this.idPersona,
      required this.nombre,
      required this.apellido,
      required this.telefono,
      required this.email,
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
            map['flagEsDoctor'] == 1, // Convierte el valor booleano a entero
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
        'flagEsDoctor':
            flagEsDoctor ? 1 : 0, // Convierte el valor booleano a entero
      };
    }

    @override
    String toString() {
      return '$nombre $apellido';
    }

    String descripcionPersona() {
      String profesion = flagEsDoctor ? 'Doctor' : 'Paciente';
      return 'Rol: $profesion \nTel: $telefono \nemail: $email \nCI: $cedula';
    }
  }
