import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/section_title.dart';
import '../providers/favorites_provider.dart';
import '../providers/movie_providers.dart';

/// Écran 2 — Détail d'un film.
///
/// Reçoit uniquement un `movieId` (String) depuis la route
/// `/movie/:id` définie dans app_router.dart. La récupération de
/// l'objet complet se fait ICI, via le repository — jamais en
/// passant l'objet Movie directement à travers la navigation.
class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On s'assure que la liste est chargée avant de chercher par id
    // (utile si l'utilisateur arrive directement sur cette route,
    // par ex. via un deep link, sans être passé par l'écran liste).
    final moviesAsync = ref.watch(allMoviesProvider);

    return moviesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: Center(child: Text('Impossible de charger le film : $error')),
      ),
      data: (_) {
        final repository = ref.watch(movieRepositoryProvider);
        final movie = repository.getById(movieId);

        if (movie == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Film introuvable')),
            body: const Center(
              child: Text('Ce film n\'existe pas ou a été supprimé.'),
            ),
          );
        }

        final favorites = ref.watch(favoritesProvider);
        final isFavorite = favorites.contains(movie.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : null,
                    ),
                    onPressed: () => ref
                        .read(favoritesProvider.notifier)
                        .toggle(movie.id),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  // Stack pour superposer un dégradé + le titre sur l'affiche.
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Hero : anime la transition de l'affiche depuis
                      // la carte de la liste (même tag que côté liste
                      // si on veut l'activer sur MovieCard aussi).
                      Hero(
                        tag: 'movie-poster-${movie.id}',
                        child: Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Text(
                          movie.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(movie.genre)),
                        Chip(label: Text('${movie.releaseYear}')),
                        Chip(label: Text('${movie.durationMinutes} min')),
                        Chip(
                          avatar: const Icon(Icons.star,
                              color: Colors.amber, size: 18),
                          label: Text(movie.rating.toStringAsFixed(1)),
                        ),
                      ],
                    ),
                    const SectionTitle('Synopsis'),
                    Text(
                      movie.synopsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SectionTitle('Réalisateur'),
                    Text(movie.director),
                    const SectionTitle('Distribution'),
                    ...movie.cast.map(
                      (actor) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 18),
                            const SizedBox(width: 8),
                            Text(actor),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
