import 'package:flutter/material.dart';
import '../../data/models/passo.dart'; // Ajuste o caminho se necessário

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
          child: Padding(
            // 1. Reduzido o padding vertical interno
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0, vertical: 16.0), // <-- MUDANÇA (era 20)
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
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),

                // 2. Reduzido o espaçador principal
                const SizedBox(height: 16), // <-- MUDANÇA (era 24)
              ],
            ),
          ),
        ),
      ),
    );
  }
}