import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:movie_app/data/repositories/movie_repository.dart';
import 'package:movie_app/data/datasources/movie_local_datasource.dart';

/// Test simple montrant l'intérêt de la séparation UI/données :
/// on peut tester la logique métier (recherche par id) sans monter
/// le moindre Widget ni lancer l'application.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getById retourne null pour un id inexistant', () {
    final repository = MovieRepository(MovieLocalDataSource());
    expect(repository.getById('id-inexistant'), isNull);
  });

  test('add() ajoute bien un film au cache', () async {
    final repository = MovieRepository(MovieLocalDataSource());
    await repository.getAll(); // force le chargement initial

    const newMovie = Movie(
      id: 'test-1',
      title: 'Film de test',
      genre: 'Drame',
      releaseYear: 2024,
      durationMinutes: 90,
      rating: 4.0,
      director: 'Test Director',
      cast: [],
      posterUrl: 'https://example.com/poster.jpg',
      synopsis: 'Synopsis de test.',
    );

    repository.add(newMovie);
    expect(repository.getById('test-1'), isNotNull);
    expect(repository.getById('test-1')!.title, 'Film de test');
  });
}
