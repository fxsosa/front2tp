class Reserva {
  int idReserva;
  int idPaciente;
  int idDoctor;
  String fecha;
  String horarioInicio;
  String horarioFin;
  bool cancelado;

  Reserva({
    required this.idReserva,
    required this.idPaciente,
    required this.idDoctor,
    required this.fecha,
    required this.horarioInicio,
    required this.horarioFin,
    this.cancelado = false,
  });

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      idReserva: map['idReserva'],
      idPaciente: map['idPaciente'],
      idDoctor: map['idDoctor'],
      fecha: map['fecha'],
      horarioInicio: map['horario_inicio'],
      horarioFin: map['horario_fin'],
      cancelado: map['cancelado'] == 1, // Convierte el valor booleano a entero
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idReserva': idReserva,
      'idPaciente': idPaciente,
      'idDoctor': idDoctor,
      'fecha': fecha,
      'horario_inicio': horarioInicio,
      'horario_fin': horarioFin,
      'cancelado': cancelado ? 1 : 0, // Convierte el valor booleano a entero
    };
  }
}
