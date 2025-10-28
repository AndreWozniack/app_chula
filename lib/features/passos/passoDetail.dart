import 'package:flutter/material.dart';
import '../../data/models/passo.dart';

class PassoDetail extends StatefulWidget {
  final Passo? passo;

  const PassoDetail({super.key, this.passo});

  @override
  State<PassoDetail> createState() => _PassoDetailState();
}

class _PassoDetailState extends State<PassoDetail> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late int _dificuldade;
  late int _criatividade;
  late int _esforcoFisico;

  bool _isInEditMode = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.passo?.nome ?? '');
    _dificuldade = widget.passo?.dificuldade ?? 1;
    _criatividade = widget.passo?.criatividade ?? 1;
    _esforcoFisico = widget.passo?.esforcoFisico ?? 1;

    if (widget.passo == null) {
      _isInEditMode = true;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  bool get _isNewPasso => widget.passo == null;

  void _salvar() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final passoAtualizado = Passo(
      id: widget.passo?.id ?? DateTime.now().toString(),
      nome: _nomeController.text,
      dificuldade: _dificuldade,
      criatividade: _criatividade,
      esforcoFisico: _esforcoFisico,
    );

    if (!_isNewPasso) {
      setState(() {
        _isInEditMode = false;
      });
    }

    Navigator.of(context).pop(passoAtualizado);
  }

  void _cancelEdit() {
    setState(() {
      _nomeController.text = widget.passo?.nome ?? '';
      _dificuldade = widget.passo?.dificuldade ?? 1;
      _criatividade = widget.passo?.criatividade ?? 1;
      _esforcoFisico = widget.passo?.esforcoFisico ?? 1;
      
      _isInEditMode = false;
    });
  }

  List<Widget> _buildAppBarActions() {
    if (_isInEditMode) {
      // --- Modo Edição ---
      return [
        if (!_isNewPasso)
          TextButton(
            onPressed: _cancelEdit,
            child: const Text('Cancelar'),
          ),
        TextButton(
          onPressed: _salvar,
          child: const Text('Salvar'),
        ),
      ];
    } else {
      // --- Modo Visualização ---
      return [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isInEditMode = true;
            });
          },
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNewPasso ? 'Novo Passo' : (_isInEditMode ? 'Editar Passo' : 'Detalhes do Passo')
        ),
        actions: _buildAppBarActions(),
      ),
      body: _isInEditMode ? _buildEditForm() : _buildReadOnlyView(),
    );
  }

  // --- WIDGET DE VISUALIZAÇÃO ---
  Widget _buildReadOnlyView() {
    final passo = widget.passo!;

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          passo.nome,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins'
              ),
        ),
        
        if (passo.criador != null && passo.criador!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              'Por: ${passo.criador!}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Poppins'
                  ),
            ),
          ),
        
        const SizedBox(height: 32),

        _BuildStatRow(
          label: 'Dificuldade',
          value: passo.dificuldade ?? 0,
        ),
        const SizedBox(height: 12),
        _BuildStatRow(
          label: 'Criatividade',
          value: passo.criatividade ?? 0,
        ),
        const SizedBox(height: 12),
        _BuildStatRow(
          label: 'Esforço Físico',
          value: passo.esforcoFisico ?? 0,
        ),
      ],
    );
  }

  // --- EDIÇÃO ---
  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome do Passo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'O nome é obrigatório';
              }
              return null;
            },
          ),
          
          // TODO: Adicionar um TextFormField para o 'Criador' se necessário

          const SizedBox(height: 32),
          _buildSlider(
            label: 'Dificuldade',
            value: _dificuldade,
            onChanged: (v) => setState(() => _dificuldade = v),
          ),
          const SizedBox(height: 16),
          _buildSlider(
            label: 'Criatividade',
            value: _criatividade,
            onChanged: (v) => setState(() => _criatividade = v),
          ),
          const SizedBox(height: 16),
          _buildSlider(
            label: 'Esforço Físico',
            value: _esforcoFisico,
            onChanged: (v) => setState(() => _esforcoFisico = v),
          ),
          const SizedBox(height: 32),
          
          if (!_isNewPasso)
            FilledButton(
              onPressed: () {
                // TODO: Implementar lógica de exclusão (ex: pop(passoComStatusDeExcluido))
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Excluir Passo'),
            ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                value.toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toString(),
          onChanged: (v) => onChanged(v.toInt()),
        ),
      ],
    );
  }
}

class _BuildStatRow extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;

  const _BuildStatRow({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 5,
  });

  @override
  Widget build(BuildContext context) {
    final double normalizedValue = (value / maxValue).clamp(0.0, 1.0);
    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            '$label:',
            style: textStyle,
          ),
        ),
        Row(children: [
                  Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: normalizedValue,
              minHeight: 12,
              backgroundColor: const Color(0xFFE8DEF8),
              color: const Color(0xFF008CFF),
            ),
          ),
        ),

        const SizedBox(width: 18),

        SizedBox(
          width: 24,
          child: Text(
            value.toString(),
            textAlign: TextAlign.right,
            style: textStyle,
          ),
        ),
        ],)
      ],
    );
  }
}