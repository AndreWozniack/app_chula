import 'package:flutter/material.dart';
import '../../data/models/festival.dart';

class FestivalDetail extends StatefulWidget {
  final Festival? festival;
  const FestivalDetail({super.key, this.festival});

  @override
  State<FestivalDetail> createState() => _FestivalDetailState();
}

class _FestivalDetailState extends State<FestivalDetail> {
  late TextEditingController nomeCtrl;
  late TextEditingController localCtrl;
  DateTime? data;

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.festival?.nome ?? '');
    localCtrl = TextEditingController(text: widget.festival?.localizacao ?? '');
    data = widget.festival?.data ?? DateTime.now();
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    localCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.festival != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Festival' : 'Novo Festival'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: localCtrl,
              decoration: const InputDecoration(
                labelText: 'Localização',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                'Data: ${data!.toLocal().toString().split(' ')[0]}',
              ),
              onPressed: () async {
                final result = await showDatePicker(
                  context: context,
                  initialDate: data!,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (result != null) {
                  setState(() => data = result);
                }
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
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