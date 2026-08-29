import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // ProviderScope racine : requis par Riverpod, rend tous les providers
  // disponibles à n'importe quel endroit de l'arbre de widgets.
  runApp(const ProviderScope(child: MovieApp()));
}
