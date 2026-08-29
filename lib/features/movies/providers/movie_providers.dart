import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/movie_local_datasource.dart';
import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';

/// Provider du repository. `Provider` simple car cet objet ne change
/// jamais de valeur pendant la vie de l'app (juste un point d'accès).
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository(MovieLocalDataSource());
});

/// Charge la liste complète depuis le repository. FutureProvider gère
/// automatiquement les 3 états (loading / data / error) exposés via
/// AsyncValue, sans qu'on ait à coder un bool `isLoading` à la main.
final allMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getAll();
});

/// État de la barre de recherche. StateProvider = juste une valeur
/// mutable, sans logique supplémentaire — suffisant ici.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Genre sélectionné dans les filtres (null = "tous les genres").
final selectedGenreProvider = StateProvider<String?>((ref) => null);

/// Provider DÉRIVÉ : combine la liste brute + la recherche + le filtre
/// genre en une seule liste finale. C'est le point clé de l'archi :
/// aucun écran ne réimplémente cette logique, ils lisent juste le
/// résultat déjà calculé. Si on ajoute un 3e filtre demain (ex. note
/// minimale), on le rajoute UNIQUEMENT ici.
final filteredMoviesProvider = Provider<AsyncValue<List<Movie>>>((ref) {
  final asyncMovies = ref.watch(allMoviesProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final genre = ref.watch(selectedGenreProvider);

  return asyncMovies.whenData((movies) {
    return movies.where((movie) {
      final matchesQuery =
          query.isEmpty || movie.title.toLowerCase().contains(query);
      final matchesGenre = genre == null || movie.genre == genre;
      return matchesQuery && matchesGenre;
    }).toList();
  });
});

/// Liste des genres disponibles, dérivée dynamiquement des données
/// (pas hardcodée en dur dans l'écran) : si demain le JSON contient
/// un nouveau genre, les filtres se mettent à jour tout seuls.
final availableGenresProvider = Provider<List<String>>((ref) {
  final asyncMovies = ref.watch(allMoviesProvider);
  return asyncMovies.maybeWhen(
    data: (movies) => movies.map((m) => m.genre).toSet().toList()..sort(),
    orElse: () => const [],
  );
});
