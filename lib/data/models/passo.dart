class Passo {
  final String id;
  final String nome;
  final String? criador;
  final int? dificuldade;
  final int? criatividade;
  final int? esforcoFisico;
  final bool? isReserva;
  final String? descricao;

  final String? varianteId;
  final List<String>? outrasVariantesIds;

  Passo({
    required this.id,
    required this.nome,
    this.criador,
    this.dificuldade,
    this.criatividade,
    this.esforcoFisico,
    this.isReserva = false,
    this.descricao,
    this.varianteId,
    this.outrasVariantesIds = const [],
  });
}
