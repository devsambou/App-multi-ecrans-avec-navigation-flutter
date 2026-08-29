import 'package:go_router/go_router.dart';

import '../../features/movies/screens/movie_list_screen.dart';
import '../../features/movies/screens/movie_detail_screen.dart';
import '../../features/movies/screens/movie_form_screen.dart';
import '../../features/movies/screens/favorites_screen.dart';

/// Configuration centralisée de la navigation.
///
/// Toutes les routes sont NOMMÉES (`name: ...`) : dans le reste de
/// l'app on navigue avec `context.goNamed('detail', ...)` plutôt
/// qu'avec des chemins écrits en dur, donc si l'URL change un jour
/// (ex. /movie/:id -> /film/:id) rien d'autre n'a besoin d'être modifié.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'list',
      path: '/',
      builder: (context, state) => const MovieListScreen(),
    ),
    GoRoute(
      name: 'detail',
      path: '/movie/:id',
      builder: (context, state) {
        // On récupère uniquement l'id depuis l'URL, jamais un objet
        // Movie complet : ça garde la route compatible avec un vrai
        // deep-link (ex. quelqu'un ouvre movie_app://movie/m3
        // directement, sans être passé par l'écran liste avant).
        final id = state.pathParameters['id']!;
        return MovieDetailScreen(movieId: id);
      },
    ),
    GoRoute(
      name: 'form',
      path: '/form',
      builder: (context, state) => const MovieFormScreen(),
    ),
    GoRoute(
      name: 'favorites',
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);
