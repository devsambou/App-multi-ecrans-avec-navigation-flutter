import 'package:flutter/material.dart';

/// Widget réutilisable n°4.
///
/// Titre de section standardisé (utilisé dans l'écran détail pour
/// "Synopsis", "Distribution", etc.), pour garantir un style visuel
/// cohérent sans dupliquer le `TextStyle` à chaque endroit.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
