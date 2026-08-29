import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/movie.dart';
import '../providers/movie_providers.dart';

/// Écran 3 — Formulaire d'ajout d'un film, avec validation.
///
/// 5 champs validés (le cahier des charges en demande ≥ 3) :
/// titre, genre, année, durée, note.
class MovieFormScreen extends ConsumerStatefulWidget {
  const MovieFormScreen({super.key});

  @override
  ConsumerState<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends ConsumerState<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();
  final _directorController = TextEditingController();

  String _genre = 'Drame';

  static const _genres = [
    'Drame',
    'Action',
    'Comédie',
    'Science-Fiction',
    'Thriller',
    'Romance',
    'Aventure',
    'Horreur',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    _ratingController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  void _submit() {
    // `validate()` déclenche tous les `validator` des TextFormField
    // ci-dessous et retourne false si au moins un échoue.
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(movieRepositoryProvider);
    repository.add(
      Movie(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        genre: _genre,
        releaseYear: int.parse(_yearController.text),
        durationMinutes: int.parse(_durationController.text),
        rating: double.parse(_ratingController.text.replaceAll(',', '.')),
        director: _directorController.text.trim(),
        cast: const [],
        posterUrl: 'https://picsum.photos/seed/${_titleController.text}/400/600',
        synopsis: 'Film ajouté manuellement depuis le formulaire.',
      ),
    );

    // Invalide le cache du FutureProvider pour forcer un rechargement
    // de la liste (le nouveau film apparaît immédiatement).
    ref.invalidate(allMoviesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film ajouté avec succès')),
      );
      context.goNamed('list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un film')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Le titre doit contenir au moins 2 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _genre,
                  decoration: const InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(),
                  ),
                  items: _genres
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) => setState(() => _genre = value!),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _directorController,
                  decoration: const InputDecoration(
                    labelText: 'Réalisateur·rice',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Année',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final year = int.tryParse(value ?? '');
                          final currentYear = DateTime.now().year;
                          if (year == null || year < 1900 || year > currentYear + 1) {
                            return 'Année invalide';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Durée (min)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final duration = int.tryParse(value ?? '');
                          if (duration == null || duration <= 0) {
                            return 'Durée invalide';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _ratingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Note (0 à 5)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final rating =
                        double.tryParse((value ?? '').replaceAll(',', '.'));
                    if (rating == null || rating < 0 || rating > 5) {
                      return 'Note invalide (entre 0 et 5)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text('Enregistrer le film'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
