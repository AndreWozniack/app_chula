import 'package:flutter/material.dart';
import '../../data/models/passo.dart';
import 'passoCard.dart';
import 'passoDetail.dart';

class PassosView extends StatefulWidget {
  const PassosView({super.key});

  @override
  State<PassosView> createState() => _PassosViewState();
}

class _PassosViewState extends State<PassosView> {
  final passos = <Passo>[
    Passo(id: '1', nome: 'Tacorrido', dificuldade: 3, criatividade: 4, esforcoFisico: 5, criador: 'André Wozniack'),
    Passo(id: '2', nome: 'Trinnca', dificuldade: 2, criatividade: 5, esforcoFisico: 3, criador: 'Arthur Wozniack'),
    Passo(id: '3', nome: 'H20', dificuldade: 2, criatividade: 5, esforcoFisico: 3, criador: 'Samuel Affornalli'),
    Passo(id: '4', nome: 'Serrote', dificuldade: 2, criatividade: 5, esforcoFisico: 3, criador: 'Leonardo Foss'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PassoDetail()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: passos.length,
        itemBuilder: (context, i) {
          final p = passos[i];
          return PassoCard(
            passo: p,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PassoDetail(passo: p)),
            ),
          );
        },
      ),
    );
  }
}