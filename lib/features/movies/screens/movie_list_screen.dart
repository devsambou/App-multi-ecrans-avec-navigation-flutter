import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/movie_card.dart';
import '../../../widgets/responsive_layout.dart';
import '../../../widgets/search_field.dart';
import '../providers/favorites_provider.dart';
import '../providers/movie_providers.dart';

/// Écran 1 — Liste des films avec recherche + filtrage par genre.
///
/// Cet écran ne contient AUCUNE donnée en dur : tout vient des
/// providers (`filteredMoviesProvider`, `availableGenresProvider`),
/// eux-mêmes alimentés par le repository qui lit le JSON.
class MovieListScreen extends ConsumerWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(filteredMoviesProvider);
    final genres = ref.watch(availableGenresProvider);
    final selectedGenre = ref.watch(selectedGenreProvider);
    final favorites = ref.watch(favoritesProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CineList'),
        actions: [
          // Bouton clair/sombre : action directe sur le provider de thème.
          IconButton(
            tooltip: 'Changer le thème',
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          IconButton(
            tooltip: 'Favoris',
            icon: const Icon(Icons.favorite),
            onPressed: () => context.goNamed('favorites'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed('form'),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchField(
                hint: 'Rechercher un film...',
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
              const SizedBox(height: 10),
              _GenreFilterRow(genres: genres, selectedGenre: selectedGenre),
              const SizedBox(height: 10),
              Expanded(
                child: moviesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => EmptyState(
                    message: 'Erreur de chargement : $error',
                    icon: Icons.error_outline,
                  ),
                  data: (movies) {
                    if (movies.isEmpty) {
                      return const EmptyState(
                        message: 'Aucun film ne correspond à ta recherche.',
                        icon: Icons.search_off,
                      );
                    }
                    // ResponsiveLayout choisit ListView (mobile) ou
                    // GridView (tablette) sans dupliquer la logique
                    // métier : les deux branches réutilisent MovieCard.
                    return ResponsiveLayout(
                      mobile: ListView.separated(
                        itemCount: movies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return SizedBox(
                            height: 160,
                            child: MovieCard(
                              title: movie.title,
                              subtitle:
                                  '${movie.genre} · ${movie.releaseYear}',
                              posterUrl: movie.posterUrl,
                              rating: movie.rating,
                              isFavorite: favorites.contains(movie.id),
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return MovieCard(
                            title: movie.title,
                            subtitle: '${movie.genre} · ${movie.releaseYear}',
                            posterUrl: movie.posterUrl,
                            rating: movie.rating,
                            isFavorite: favorites.contains(movie.id),
                            onFavoriteTap: () => ref
                                .read(favoritesProvider.notifier)
                                .toggle(movie.id),
                            onTap: () => context.goNamed(
                              'detail',
                              pathParameters: {'id': movie.id},
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rangée de filtres par genre (ChoiceChip), horizontale et scrollable.
/// Séparée en widget privé pour garder `build()` de l'écran lisible.
class _GenreFilterRow extends ConsumerWidget {
  const _GenreFilterRow({required this.genres, required this.selectedGenre});

  final List<String> genres;
  final String? selectedGenre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = selectedGenre == genre;
          return ChoiceChip(
            label: Text(genre),
            selected: isSelected,
            onSelected: (_) {
              // Toggle : cliquer sur le genre déjà sélectionné le désélectionne.
              ref.read(selectedGenreProvider.notifier).state =
                  isSelected ? null : genre;
            },
          );
        },
      ),
    );
  }
}
