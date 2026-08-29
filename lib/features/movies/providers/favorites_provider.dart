import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gère l'ensemble des ids de films favoris.
///
/// On stocke des `id` (String), jamais des objets `Movie`, pour la
/// même raison que la navigation : rester découplé du modèle complet
/// et éviter les doublons d'objets en mémoire.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{});

  void toggle(String movieId) {
    final updated = {...state};
    if (updated.contains(movieId)) {
      updated.remove(movieId);
    } else {
      updated.add(movieId);
    }
    state = updated;
  }

  bool isFavorite(String movieId) => state.contains(movieId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
