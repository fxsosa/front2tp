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
    flagEsDoctor BOOLEAN NOT NULL
  );
  ''',
  '''
  CREATE TABLE Reservas (
    idReserva INTEGER PRIMARY KEY,
    idPaciente INTEGER,
    idDoctor INTEGER,
    idCategoria INTEGER,
    fecha DATE NOT NULL,
    horario_inicio TIME NOT NULL,
    horario_fin TIME NOT NULL,
    cancelado BOOLEAN DEFAULT 0,
    FOREIGN KEY (idPaciente) REFERENCES Personas(idPersona),
    FOREIGN KEY (idDoctor) REFERENCES Personas(idPersona),
    FOREIGN KEY (idCategoria) REFERENCES Categorias(idCategoria)
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

// inicializa la db
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
          'nombre': 'Juan',
          'apellido': 'López',
          'telefono': '123-456-7890',
          'email': 'juan.perez@example.com',
          'cedula': '111111111',
          'flagEsDoctor': 1,
        },
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'María',
          'apellido': 'Martínez',
          'telefono': '987-654-3210',
          'email': 'maria.gonzalez@example.com',
          'cedula': '222222222',
          'flagEsDoctor': 1,
        },
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'Ana',
          'apellido': 'Rodríguez',
          'telefono': '555-555-5555',
          'email': 'ana.rodriguez@example.com',
          'cedula': '333333333',
          'flagEsDoctor': 0,
        },
      },
      {
        'table': 'Personas',
        'values': {
          'nombre': 'Luis',
          'apellido': 'Torres',
          'telefono': '666-666-6666',
          'email': 'luis.torres@example.com',
          'cedula': '444444444',
          'flagEsDoctor': 0,
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
          'idCategoria': 1,
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
          'idCategoria': 1,
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
    return db.rawInsert(
        'INSERT INTO Personas (nombre, apellido, telefono, email, cedula, flagEsDoctor) VALUES(?, ?, ?, ?, ?, ?)',
        [
          persona.nombre,
          persona.apellido,
          persona.telefono,
          persona.email,
          persona.cedula,
          persona.flagEsDoctor
        ]);
  }

  // deletes
  static Future<int> deleteCategoria(Categoria categoria) async {
    Database db = await _openDB();
    return db.delete("Categorias",
        where: "idCategoria = ?", whereArgs: [categoria.idCategoria]);
  }

  static Future<int> deletePersona(Persona persona) async {
    Database db = await _openDB();
    return db.delete("Personas",
        where: "idPersona = ?", whereArgs: [persona.idPersona]);
  }

  //update
  static Future<int> updateCategoria(Categoria categoria) async {
    Database db = await _openDB();
    return db.update("Categorias", categoria.toMap(),
        where: "idCategoria = ?", whereArgs: [categoria.idCategoria]);
  }

  static Future<int> updatePersona(Persona persona) async {
    Database db = await _openDB();
    return db.update("Personas", persona.toMap(),
        where: "idPersona = ?", whereArgs: [persona.idPersona]);
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


  // getAllByNamePersona
  static Future<List<Persona>> getAllByNamePersona(String nombre) async {
    Database db = await _openDB();

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Personas WHERE nombre=?', [nombre]);

    if (result.isNotEmpty) {
      return List.generate(
        result.length,
        (i) => Persona(
          idPersona: result[i]['idPersona'],
          nombre: result[i]['nombre'],
          apellido: result[i]['apellido'],
          telefono: result[i]['telefono'],
          email: result[i]['email'],
          cedula: result[i]['cedula'],
          flagEsDoctor: result[i]['flagEsDoctor'] == 1,
        ),
      );
    } else {
      throw Exception('Persona no encontrada');
    }
  }

  // getAllByNameDoctor
  static Future<List<Persona>> getAllByNameDoctor(String nombre) async {
    Database db = await _openDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM Personas WHERE nombre=? AND flagEsDoctor=1', [nombre]);

    if (result.isNotEmpty) {
      return List.generate(
        result.length,
        (i) => Persona(
          idPersona: result[i]['idPersona'],
          nombre: result[i]['nombre'],
          apellido: result[i]['apellido'],
          telefono: result[i]['telefono'],
          email: result[i]['email'],
          cedula: result[i]['cedula'],
          flagEsDoctor: result[i]['flagEsDoctor'] == 1,
        ),
      );
    } else {
      throw Exception('Doctor no encontrado');
    }
  }

  // getAllByNamePaciente
  static Future<List<Persona>> getAllByNamePaciente(String nombre) async {
    Database db = await _openDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM Personas WHERE nombre=? AND flagEsDoctor=0', [nombre]);

    if (result.isNotEmpty) {
      return List.generate(
        result.length,
        (i) => Persona(
          idPersona: result[i]['idPersona'],
          nombre: result[i]['nombre'],
          apellido: result[i]['apellido'],
          telefono: result[i]['telefono'],
          email: result[i]['email'],
          cedula: result[i]['cedula'],
          flagEsDoctor: result[i]['flagEsDoctor'] == 1,
        ),
      );
    } else {
      throw Exception('Paciente no encontrado');
    }
  }

  //getAllByNameCategoria
  static Future<List<Categoria>> getAllByNameCategoria(String nombre) async {
    Database db = await _openDB();

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Categorias WHERE descripcion=?', [nombre]);

    if (result.isNotEmpty) {
      return List.generate(
        result.length,
        (i) => Categoria(
          idCategoria: result[i]['idCategoria'],
          descripcion: result[i]['descripcion'],
        ),
      );
    } else {
      throw Exception('Categoria no encontrada');
    }
  }

  static Future<Persona> getOneByIdPersona(Persona persona) async {
    Database db = await _openDB();
    int idPersona = persona.idPersona;

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Personas WHERE idPersona=?', [idPersona]);

    if (result.isNotEmpty) {
      return Persona.fromMap(result.first);
    } else {
      throw Exception('Persona no encontrada');
    }
  }

  static Future<Persona> getOneByIdPersonaDeVerdad(int idPersona) async {
    Database db = await _openDB();
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Personas WHERE idPersona=?', [idPersona]);

    if (result.isNotEmpty) {
      return Persona.fromMap(result.first);
    } else {
      throw Exception('Persona no encontrada');
    }
  }

  static Future<Categoria> getOneByIdCategoriaDeVerdad(int idCategoria) async {
    Database db = await _openDB();

    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Categorias WHERE idCategoria=?', [idCategoria]);

    if (result.isNotEmpty) {
      return Categoria.fromMap(result.first);
    } else {
      throw Exception('Categoria no encontrada');
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

  static Future<List<FichaClinica>> getAllFichasClinicas() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> fichasClinicasMap =
        await db.query("FichasClinicas");

    return List.generate(
        fichasClinicasMap.length,
        (i) => FichaClinica(
            idFicha: fichasClinicasMap[i]['idFicha'],
            idPaciente: fichasClinicasMap[i]['idPaciente'],
            idDoctor: fichasClinicasMap[i]['idDoctor'],
            fecha: fichasClinicasMap[i]['fecha'],
            motivoConsulta: fichasClinicasMap[i]['motivoConsulta'],
            diagnostico: fichasClinicasMap[i]['diagnostico'],
            idCategoria: fichasClinicasMap[i]['idCategoria']));
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

  // Método para obtener todas las personas que son doctores
  static Future<List<Persona>> getAllDoctores() async {
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
    ).where((element) => element.flagEsDoctor).toList();
  }

  // Método para obtener todas las personas que no son doctores
  static Future<List<Persona>> getAllPacientes() async {
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
    ).where((element) => !element.flagEsDoctor).toList();
  }

   // Método para obtener todas las reservas
  static Future<List<Reserva>> obtenerReservas() async {
    final Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query('Reservas');

    return List.generate(maps.length, (i) {
      return Reserva.fromMap(maps[i]);
    });
  }

  // Método para guardar o actualizar una reserva
  static Future<void> guardarReserva(Reserva reserva) async {
    final Database db = await _openDB()	;
    if (reserva.idReserva == 0) {
      // Si la reserva es nueva (idReserva == 0), la insertamos
      await db.insert(
        'Reservas',
        reserva.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Si la reserva ya existe, la actualizamos
      await db.update(
        'Reservas',
        reserva.toMap(),
        where: 'idReserva = ?',
        whereArgs: [reserva.idReserva],
      );
    }
  }

  static Future<void> guardarFicha(FichaClinica fichaClinica) async {
    final Database db = await _openDB();
    if (fichaClinica.idFicha == 0) {
      // Si la ficha es nueva (idFicha == 0), la insertamos
      await db.insert(
        'FichasClinicas',
        fichaClinica.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Si la ficha ya existe, la actualizamos
      await db.update(
        'FichasClinicas',
        fichaClinica.toMap(),
        where: 'idFicha = ?',
        whereArgs: [fichaClinica.idFicha],
      );
    }
  }
}
