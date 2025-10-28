import 'package:flutter/material.dart';
import '../../data/models/festival.dart';
import 'festivalDetail.dart';

class FastivalsView extends StatefulWidget {
  const FastivalsView({super.key});

  @override
  State<FastivalsView> createState() => _FastivalsViewState();
}

class _FastivalsViewState extends State<FastivalsView> {
  final festivais = <Festival>[
    Festival(
      id: '1',
      nome: 'Festival de Pelotas',
      data: DateTime(2025, 11, 10),
      localizacao: 'Pelotas',
    ),
    Festival(
      id: '2',
      nome: 'Festival de Vacaria',
      data: DateTime(2026, 1, 25),
      localizacao: 'Vacaria',
    ),
  ];

  int modo = 0; // 0 = Lista, 1 = Calendário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Festivais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FestivalDetail()),
            ),
          ),
        ],
      ),
      body: modo == 0 ? _buildList() : _buildCalendar(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: festivais.length,
      itemBuilder: (context, i) {
        final f = festivais[i];
        return ListTile(
          title: Text(f.nome),
          subtitle: Text(
            '${f.localizacao} — ${f.data.toLocal().toString().split(' ')[0]}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FestivalDetail(festival: f)),
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return const Center(
      child: Text('Visualização de calendário (TODO)'),
    );
  }
}