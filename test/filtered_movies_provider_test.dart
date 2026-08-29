import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_app/data/models/movie.dart';
import 'package:movie_app/features/movies/providers/movie_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('filteredMoviesProvider combines search query and genre filter',
      () async {
    final container = ProviderContainer();

    // Attendre le chargement initial des films
    final initialMovies = await container.read(allMoviesProvider.future);
    expect(initialMovies, isNotEmpty,
        reason: 'Les films doivent être chargés depuis le JSON');

    // Initialiser le provider filtré sans filtres
    var filtered = container.read(filteredMoviesProvider);
    expect(
        filtered.when(
          data: (movies) => movies,
          loading: () => null,
          error: (error, stack) => null,
        ),
        isNotNull);

    // Appliquer un filtre de recherche
    container.read(searchQueryProvider.notifier).state = 'Écho';
    await Future.delayed(const Duration(milliseconds: 100));

    filtered = container.read(filteredMoviesProvider);
    var filteredMovies = filtered.when(
      data: (movies) => movies,
      loading: () => <Movie>[],
      error: (error, stack) => <Movie>[],
    );

    // Vérifier que seuls les films contenant "Écho" dans le titre sont retournés
    for (var movie in filteredMovies) {
      expect(movie.title.toLowerCase(), contains('écho'));
    }

    // Réinitialiser la recherche
    container.read(searchQueryProvider.notifier).state = '';
    await Future.delayed(const Duration(milliseconds: 100));

    // Appliquer un filtre par genre
    container.read(selectedGenreProvider.notifier).state = 'Drame';
    await Future.delayed(const Duration(milliseconds: 100));

    filtered = container.read(filteredMoviesProvider);
    filteredMovies = filtered.when(
      data: (movies) => movies,
      loading: () => <Movie>[],
      error: (error, stack) => <Movie>[],
    );

    // Vérifier que seuls les films du genre "Drame" sont retournés
    for (var movie in filteredMovies) {
      expect(movie.genre, equals('Drame'));
    }
  });

  test('availableGenresProvider returns unique genres from movies', () async {
    final container = ProviderContainer();

    // Attendre le chargement initial des films
    await container.read(allMoviesProvider.future);

    // Lire le provider des genres disponibles
    final genres = container.read(availableGenresProvider);

    // Vérifier qu'il y a au moins un genre
    expect(genres, isNotEmpty);

    // Vérifier qu'il n'y a pas de doublon
    expect(genres.length, equals(genres.toSet().length));

    // Vérifier que la liste est triée
    expect(genres, equals(genres..sort()));
  });
}
