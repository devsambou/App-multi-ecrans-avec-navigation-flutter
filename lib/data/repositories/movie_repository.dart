import '../datasources/movie_local_datasource.dart';
import '../models/movie.dart';

/// Point d'entrée unique pour accéder aux films depuis le reste de
/// l'app. Les écrans ne parlent JAMAIS directement au datasource :
/// ils passent par ce repository. Ça permet de changer la source de
/// données (JSON local -> API -> base locale) sans casser l'UI.
class MovieRepository {
  MovieRepository(this._dataSource);
  final MovieLocalDataSource _dataSource;

  List<Movie> _cache = [];

  Future<List<Movie>> getAll() async {
    if (_cache.isEmpty) {
      _cache = await _dataSource.loadMovies();
    }
    return _cache;
  }

  /// Récupère un film par id. Utilisé par l'écran détail, qui reçoit
  /// uniquement un `id` (String) depuis l'URL — jamais l'objet Movie
  /// complet — pour rester compatible avec le deep-linking.
  Movie? getById(String id) {
    try {
      return _cache.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Ajoute un film créé depuis le formulaire. En mémoire uniquement
  /// pour cette démo ; dans une vraie app on écrirait ici vers une
  /// base locale (sqflite/Hive) ou une API.
  void add(Movie movie) {
    _cache = [..._cache, movie];
  }
}
