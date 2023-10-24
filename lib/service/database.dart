import 'package:front2tp/model/ficha.dart';
import 'package:front2tp/model/persona_doctor.dart';
import 'package:front2tp/model/reserva.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:front2tp/model/categoria.dart';

List<String> tableCreationQueries = [
  '''
  CREATE TABLE Categorias (
    idCategoria INTEGER PRIMARY KEY,
    descripcion TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE Personas (
    idPersona INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    telefono TEXT,
    email TEXT,
    cedula TEXT NOT NULL,
    flag_es_doctor BOOLEAN NOT NULL
  );
  ''',
  '''
  CREATE TABLE Reservas (
    idReserva INTEGER PRIMARY KEY,
    idPaciente INTEGER,
    idDoctor INTEGER,
    fecha DATE NOT NULL,
    horario_inicio TIME NOT NULL,
    horario_fin TIME NOT NULL,
    cancelado BOOLEAN DEFAULT 0,
    FOREIGN KEY (idPaciente) REFERENCES Personas(idPersona),
    FOREIGN KEY (idDoctor) REFERENCES Personas(idPersona)
  );
  ''',
  '''
  CREATE TABLE FichasClinicas (
    idFicha INTEGER PRIMARY KEY,
    idPaciente INTEGER,
    idDoctor INTEGER,
    fecha DATE NOT NULL,
    motivoConsulta TEXT,
    diagnostico TEXT,
    idCategoria INTEGER,
    FOREIGN KEY (idPaciente) REFERENCES Personas(idPersona),
    FOREIGN KEY (idDoctor) REFERENCES Personas(idPersona),
    FOREIGN KEY (idCategoria) REFERENCES Categorias(idCategoria)
  );
  ''',
];

class db {
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'hospital.db'),
      onCreate: (db, version) {
        for (String query in tableCreationQueries) {
          db.execute(query);
        }
        return insertDataBatch(db);
      },
      version: 1,
    );
  }

  // Funcion para poblar la bd
  static Future<void> insertDataBatch(Database database) async {
    Batch batch = database.batch();

    List<Map<String, dynamic>> dataToInsert = [
      {
        'table': 'Categorias',
        'values': {'descripcion': 'Cardiología'},
      },
      {
        'table': 'Categorias',
        'values': {'descripcion': 'Dermatología'},
      },
      {
        'table': 'Categorias',
        'values': {'descripcion': 'Ginecología'},
      },
      {
        'table': 'Categorias',
        'values': {'descripcion': 'Ortopedia'},
      },
      {
        'table': 'Categorias',
        'values': {'descripcion': 'Pediatría'},
      },
      {
        'table': 'Categorias',
        'values': {'descripcion': 'Neurología'},
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'Dr. Juan Pérez',
          'apellido': 'López',
          'telefono': '123-456-7890',
          'email': 'juan.perez@example.com',
          'cedula': '111111111',
          'flag_es_doctor': 1,
        },
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'Dra. María González',
          'apellido': 'Martínez',
          'telefono': '987-654-3210',
          'email': 'maria.gonzalez@example.com',
          'cedula': '222222222',
          'flag_es_doctor': 1,
        },
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'Paciente',
          'apellido': 'Ana Rodríguez',
          'telefono': '555-555-5555',
          'email': 'ana.rodriguez@example.com',
          'cedula': '333333333',
          'flag_es_doctor': 0,
        },
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'Paciente',
          'apellido': 'Luis Torres',
          'telefono': '666-666-6666',
          'email': 'luis.torres@example.com',
          'cedula': '444444444',
          'flag_es_doctor': 0,
        },
      },
      {
        'table': 'Reservas',
        'values': {
          'idPaciente': 3,
          'idDoctor': 1,
          'fecha': '2023-10-21',
          'horario_inicio': '08:00:00',
          'horario_fin': '09:00:00',
          'cancelado': 0,
        },
      },
      {
        'table': 'Reservas',
        'values': {
          'idPaciente': 4,
          'idDoctor': 2,
          'fecha': '2023-10-22',
          'horario_inicio': '10:00:00',
          'horario_fin': '11:00:00',
          'cancelado': 1,
        },
      },
      {
        'table': 'FichasClinicas',
        'values': {
          'idPaciente': 3,
          'idDoctor': 1,
          'fecha': '2023-10-21',
          'motivoConsulta': 'Dolor de cabeza',
          'diagnostico': 'Cefalea tensional',
          'idCategoria': 1,
        },
      },
      {
        'table': 'FichasClinicas',
        'values': {
          'idPaciente': 4,
          'idDoctor': 2,
          'fecha': '2023-10-22',
          'motivoConsulta': 'Fiebre alta',
          'diagnostico': 'Infección respiratoria',
          'idCategoria': 2,
        },
      },
    ];

    for (var data in dataToInsert) {
      String table = data['table'];
      Map<String, dynamic> values = data['values'];

      String columns = values.keys.join(', ');
      List<dynamic> placeholders = values.keys.map((_) => '?').toList();
      String query =
          'INSERT INTO $table ($columns) VALUES (${placeholders.join(', ')})';

      batch.rawInsert(query, values.values.toList());
    }

    await batch.commit();
    print('Inserciones múltiples exitosas (usando batch).');
  }

  // Inserts
  static Future<int> insertCategoria(Categoria categoria) async {
    Database db = await _openDB();
    return db.rawInsert('INSERT INTO CATEGORIAS (descripcion) VALUES(?)',
        [categoria.descripcion]);
  }

  static Future<int> insertPersona(Persona persona) async {
    Database db = await _openDB();
    return db.insert("Persona", persona.toMap());
  }

  static Future<int> insertReserva(Reserva reserva) async {
    Database db = await _openDB();
    return db.insert("Reserva", reserva.toMap());
  }

  static Future<int> insertFicha(FichaClinica ficha) async {
    Database db = await _openDB();
    return db.insert("FichasClinica", ficha.toMap());
  }

  // deletes
  static Future<int> deleteCategoria(Categoria categoria) async {
    Database db = await _openDB();
    return db.delete("Categorias",
        where: "idCategoria = ?", whereArgs: [categoria.idCategoria]);
  }

  static Future<int> deletePersona(Persona persona) async {
    Database db = await _openDB();
    return db.delete("Persona",
        where: "idPersona = ?", whereArgs: [persona.idPersona]);
  }

  static Future<int> deleteReserva(Reserva reserva) async {
    Database db = await _openDB();
    return db.delete("Reserva",
        where: "idReserva = ?", whereArgs: [reserva.idReserva]);
  }

  static Future<int> deleteFicha(FichaClinica ficha) async {
    Database db = await _openDB();
    return db.delete("FichasClinicas",
        where: "idFicha = ?", whereArgs: [ficha.idFicha]);
  }

  //update
  static Future<int> updateCategoria(Categoria categoria) async {
    Database db = await _openDB();
    return db.update("Categorias", categoria.toMap(),
        where: "idCategoria = ?", whereArgs: [categoria.idCategoria]);
  }

  static Future<int> updatePersona(Persona persona) async {
    Database db = await _openDB();
    return db.update("Persona", persona.toMap(),
        where: "idPersona = ?", whereArgs: [persona.idPersona]);
  }

  static Future<int> updateReserva(Reserva reserva) async {
    Database db = await _openDB();
    return db.update("Reserva", reserva.toMap(),
        where: "idReserva = ?", whereArgs: [reserva.idReserva]);
  }

  static Future<int> updateFicha(FichaClinica ficha) async {
    Database db = await _openDB();
    return db.update("FichasClinicas", ficha.toMap(),
        where: "idFicha = ?", whereArgs: [ficha.idFicha]);
  }

  // getOneByIdCategoria
  static Future<Categoria> getOneByIdCategoria(Categoria categoria) async {
    Database db = await _openDB();
    int idCategoria = categoria.idCategoria;

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM CATEGORIAS WHERE idCategoria=?', [idCategoria]);

    if (result.isNotEmpty) {
      return Categoria.fromMap(result.first);
    } else {
      throw Exception('Categoria no encontrada');
    }
  }

  static Future<Categoria> getOneByIdPersona(Persona persona) async {
    Database db = await _openDB();
    int idPersona = persona.idPersona;

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Persona WHERE idPersona=?', [idPersona]);

    if (result.isNotEmpty) {
      return Categoria.fromMap(result.first);
    } else {
      throw Exception('Persona no encontrada');
    }
  }

  static Future<Categoria> getOneByIdReserva(Reserva reserva) async {
    Database db = await _openDB();
    int idReserva = reserva.idReserva;

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Reserva WHERE idReserva=?', [idReserva]);

    if (result.isNotEmpty) {
      return Categoria.fromMap(result.first);
    } else {
      throw Exception('Reserva no encontrada');
    }
  }

  static Future<Categoria> getOneByIdFicha(FichaClinica ficha) async {
    Database db = await _openDB();
    int idFicha = ficha.idFicha;

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM FichasClinicas WHERE idFicha=?', [idFicha]);

    if (result.isNotEmpty) {
      return Categoria.fromMap(result.first);
    } else {
      throw Exception('Ficha no encontrada');
    }
  }

  //getAll
  static Future<List<Categoria>> getAllCategorias() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> categoriasMap =
        await db.query("Categorias");

    return List.generate(
        categoriasMap.length,
        (i) => Categoria(
            idCategoria: categoriasMap[i]['idCategoria'],
            descripcion: categoriasMap[i]['descripcion']));
  }

  static Future<List<Persona>> getAllPersonas() async {
    Database db = await _openDB();

    // Realiza una consulta para obtener todas las personas
    final List<Map<String, dynamic>> personasMap = await db.query("Personas");

    // Mapea los resultados en objetos Persona
    return List.generate(
      personasMap.length,
      (i) => Persona(
        idPersona: personasMap[i]['idPersona'],
        nombre: personasMap[i]['nombre'],
        apellido: personasMap[i]['apellido'],
        telefono: personasMap[i]['telefono'],
        email: personasMap[i]['email'],
        cedula: personasMap[i]['cedula'],
        flagEsDoctor: personasMap[i]['flagEsDoctor'] ==
            1, // Convierte 1 a true y 0 a false
      ),
    );
  }

  static Future<List<Reserva>> getAllReservas() async {
    Database db = await _openDB();

    // Realiza una consulta para obtener todas las reservas
    final List<Map<String, dynamic>> reservasMap = await db.query("Reservas");

    // Mapea los resultados en objetos Reserva
    return List.generate(
      reservasMap.length,
      (i) => Reserva(
        idReserva: reservasMap[i]['idReserva'],
        idPaciente: reservasMap[i]['idPaciente'],
        idDoctor: reservasMap[i]['idDoctor'],
        fecha: reservasMap[i]['fecha'],
        horarioInicio: reservasMap[i]['horarioInicio'],
        horarioFin: reservasMap[i]['horarioFin'],
        cancelado:
            reservasMap[i]['cancelado'] == 1, // Convierte 1 a true y 0 a false
      ),
    );
  }

  static Future<List<FichaClinica>> getAllFichasClinicas() async {
    Database db = await _openDB();

    // Realiza una consulta para obtener todas las fichas clínicas
    final List<Map<String, dynamic>> fichasClinicasMap =
        await db.query("FichasClinicas");

    // Mapea los resultados en objetos FichaClinica
    return List.generate(
      fichasClinicasMap.length,
      (i) => FichaClinica(
        idFicha: fichasClinicasMap[i]['idFicha'],
        idPaciente: fichasClinicasMap[i]['idPaciente'],
        idDoctor: fichasClinicasMap[i]['idDoctor'],
        fecha: fichasClinicasMap[i]['fecha'],
        motivoConsulta: fichasClinicasMap[i]['motivoConsulta'],
        diagnostico: fichasClinicasMap[i]['diagnostico'],
        idCategoria: fichasClinicasMap[i]['idCategoria'],
      ),
    );
  }
}
