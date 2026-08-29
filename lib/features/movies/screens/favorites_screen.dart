import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/empty_state.dart';
import '../../../widgets/movie_card.dart';
import '../../../widgets/responsive_layout.dart';
import '../providers/favorites_provider.dart';
import '../providers/movie_providers.dart';

/// Écran 4 — Favoris.
///
/// Démontre la réutilisation : mêmes widgets (`MovieCard`,
/// `ResponsiveLayout`, `EmptyState`) que l'écran liste, juste
/// nourris par une source filtrée différente (les favoris).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final moviesAsync = ref.watch(allMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: moviesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => EmptyState(
          message: 'Erreur : $error',
          icon: Icons.error_outline,
        ),
        data: (movies) {
          final favoriteMovies =
              movies.where((m) => favoriteIds.contains(m.id)).toList();

          if (favoriteMovies.isEmpty) {
            return const EmptyState(
              message: 'Aucun favori pour le moment.\n'
                  'Ajoute des films depuis l\'écran principal.',
              icon: Icons.favorite_border,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: ResponsiveLayout(
              mobile: ListView.separated(
                itemCount: favoriteMovies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final movie = favoriteMovies[index];
                  return SizedBox(
                    height: 160,
                    child: MovieCard(
                      title: movie.title,
                      subtitle: '${movie.genre} · ${movie.releaseYear}',
                      posterUrl: movie.posterUrl,
                      rating: movie.rating,
                      isFavorite: true,
                      onFavoriteTap: () => ref
                          .read(favoritesProvider.notifier)
                          .toggle(movie.id),
                      onTap: () => context.goNamed(
                        'detail',
                        pathParameters: {'id': movie.id},
                      ),
                    ),
                  );
                },
              ),
              tablet: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemCount: favoriteMovies.length,
                itemBuilder: (context, index) {
                  final movie = favoriteMovies[index];
                  return MovieCard(
                    title: movie.title,
                    subtitle: '${movie.genre} · ${movie.releaseYear}',
                    posterUrl: movie.posterUrl,
                    rating: movie.rating,
                    isFavorite: true,
                    onFavoriteTap: () =>
                        ref.read(favoritesProvider.notifier).toggle(movie.id),
                    onTap: () => context.goNamed(
                      'detail',
                      pathParameters: {'id': movie.id},
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
