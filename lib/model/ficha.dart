class FichaClinica {
  int idFicha;
  int idPaciente;
  int idDoctor;
  String fecha;
  String motivoConsulta;
  String diagnostico;
  int idCategoria;

  FichaClinica({
    required this.idFicha,
    required this.idPaciente,
    required this.idDoctor,
    required this.fecha,
    required this.motivoConsulta,
    required this.diagnostico,
    required this.idCategoria,
  });

  factory FichaClinica.fromMap(Map<String, dynamic> map) {
    return FichaClinica(
      idFicha: map['idFicha'],
      idPaciente: map['idPaciente'],
      idDoctor: map['idDoctor'],
      fecha: map['fecha'],
      motivoConsulta: map['motivoConsulta'],
      diagnostico: map['diagnostico'],
      idCategoria: map['idCategoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idFicha': idFicha,
      'idPaciente': idPaciente,
      'idDoctor': idDoctor,
      'fecha': fecha,
      'motivoConsulta': motivoConsulta,
      'diagnostico': diagnostico,
      'idCategoria': idCategoria,
    };
  }
}
