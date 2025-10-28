import 'package:flutter/material.dart';
import 'sequenceDetail.dart';
import '../../data/models/sequence.dart';

class SequencesView extends StatefulWidget {
  const SequencesView({super.key});

  @override
  State<SequencesView> createState() => _SequencesViewState();
}

class _SequencesViewState extends State<SequencesView> {
  final sequences = <Sequence>[
    Sequence(id: '1', titulo: 'Sequência 1', descricao: 'Primeira sequência', idsPassos: []),
    Sequence(id: '2', titulo: 'Sequência 2', descricao: 'Treino intermediário', idsPassos: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sequências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SequenceDetail()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sequences.length,
        itemBuilder: (context, index) {
          final seq = sequences[index];
          return ListTile(
            title: Text(seq.titulo),
            subtitle: Text(seq.descricao),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SequenceDetail(sequence: seq)),
              );
            },
          );
        },
      ),
    );
  }
}