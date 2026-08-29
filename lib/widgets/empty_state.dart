import 'package:flutter/material.dart';

/// Widget réutilisable n°3.
///
/// État vide générique (aucun résultat, liste vide, erreur douce...).
/// Prend un message et une icône en paramètre : peut servir pour la
/// recherche de films, pour la liste de favoris vide, etc.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    required this.icon,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.disabledColor),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.disabledColor),
            ),
          ],
        ),
      ),
    );
  }
}
