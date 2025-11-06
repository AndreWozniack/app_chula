import 'package:flutter/material.dart';
import '../../data/models/passo.dart';

class PassoCard extends StatelessWidget {
  final Passo passo;
  final VoidCallback? onTap;

  const PassoCard({
    super.key,
    required this.passo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color.fromARGB(62, 79, 79, 79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(41),
          ),
        ),
        child: InkWell(
            onTap: onTap,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passo.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      passo.criador != null && passo.criador!.isNotEmpty
                          ? 'Criador: ${passo.criador}'
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Specs Row
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //   child: const Divider(
              //     color: Colors.white54,
              //     thickness: 0.3,
              //     height: 0.2,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Row(spacing: 20,
              // mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _SpecsInfo(label: 'Dificuldade', value: passo.dificuldade),
              //     _SpecsInfo(label: 'Criatividade', value: passo.criatividade),
              //     _SpecsInfo(label: 'Esforço Físico', value: passo.esforcoFisico),
              //   ],
              // ),
              const SizedBox(height: 16),
            ])),
      ),
    );
  }
}

class _SpecsInfo extends StatelessWidget {
  final String label;
  final int? value;

  const _SpecsInfo({
    required this.label,
    this.value = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
