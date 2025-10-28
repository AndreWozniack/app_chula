class Sequence {
  final String id;
  final String titulo;
  final String descricao;

  final String? festivalId;
  final List<String> idsPassos;

  Sequence({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.festivalId,
    required this.idsPassos,
  });
}