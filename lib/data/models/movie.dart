/// Modèle de données pur : aucune dépendance à Flutter ici
/// (pas de Widget, pas de BuildContext, pas de couleur).
/// C'est ce qui permet de tester ce modèle sans monter d'UI.
class Movie {
  final String id;
  final String title;
  final String genre;
  final int releaseYear;
  final int durationMinutes;
  final double rating;
  final String director;
  final List<String> cast;
  final String posterUrl;
  final String synopsis;

  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.releaseYear,
    required this.durationMinutes,
    required this.rating,
    required this.director,
    required this.cast,
    required this.posterUrl,
    required this.synopsis,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as String,
        title: json['title'] as String,
        genre: json['genre'] as String,
        releaseYear: json['releaseYear'] as int,
        durationMinutes: json['durationMinutes'] as int,
        rating: (json['rating'] as num).toDouble(),
        director: json['director'] as String,
        cast: List<String>.from(json['cast'] as List),
        posterUrl: json['posterUrl'] as String,
        synopsis: json['synopsis'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'genre': genre,
        'releaseYear': releaseYear,
        'durationMinutes': durationMinutes,
        'rating': rating,
        'director': director,
        'cast': cast,
        'posterUrl': posterUrl,
        'synopsis': synopsis,
      };
}
