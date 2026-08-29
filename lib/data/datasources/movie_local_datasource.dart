import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/movie.dart';

/// Couche la plus basse : sait uniquement lire des octets/JSON et
/// les transformer en objets Dart. Si demain on remplace le JSON
/// local par un appel HTTP, seule CETTE classe change — ni le
/// repository, ni les providers, ni les écrans n'ont à être touchés.
class MovieLocalDataSource {
  Future<List<Movie>> loadMovies() async {
    final raw = await rootBundle.loadString('assets/data/movies.json');
    final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
    return jsonList
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
