import 'package:flutter/material.dart';
import '../../data/models/sequence.dart';

class SequenceDetail extends StatefulWidget {
  final Sequence? sequence;
  const SequenceDetail({super.key, this.sequence});

  @override
  State<SequenceDetail> createState() => _SequenceDetailState();
}

class _SequenceDetailState extends State<SequenceDetail> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.sequence?.titulo ?? '');
    descCtrl = TextEditingController(text: widget.sequence?.descricao ?? '');
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.sequence != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Sequência' : 'Nova Sequência'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: deletar
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // TODO: salvar/criar
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(isEdit ? 'Salvar' : 'Criar'),
            ),
          ],
        ),
      ),
    );
  }
}