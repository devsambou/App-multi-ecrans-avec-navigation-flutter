import 'package:flutter/material.dart';

/// Widget réutilisable n°2.
///
/// Champ de recherche générique : ne sait rien des "films", juste
/// un texte d'aide et un callback `onChanged`. Utilisable tel quel
/// pour rechercher n'importe quoi ailleurs dans l'app.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
