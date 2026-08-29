import 'package:flutter/material.dart';

/// Widget réutilisable n°5.
///
/// IMPORTANT : ce widget prend des String/double/callback en
/// paramètres, jamais un objet `Movie`. C'est ce qui le rend
/// vraiment réutilisable (on pourrait s'en servir pour afficher
/// une série, un livre, un restaurant...) plutôt que d'être un
/// simple bout d'UI copié-collé qui dépend du modèle métier.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.posterUrl,
    required this.rating,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  final String title;
  final String subtitle;
  final String posterUrl;
  final double rating;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack : superpose le badge favori sur l'affiche.
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    posterUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.movie_outlined, size: 32),
                    ),
                  ),
                  if (onFavoriteTap != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _FavoriteBadge(
                        isFavorite: isFavorite,
                        onTap: onFavoriteTap!,
                      ),
                    ),
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: _RatingBadge(rating: rating),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteBadge extends StatelessWidget {
  const _FavoriteBadge({required this.isFavorite, required this.onTap});
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.black.withValues(alpha: 0.55),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.redAccent : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 14),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
