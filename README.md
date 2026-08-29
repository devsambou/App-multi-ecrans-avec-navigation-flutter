# 🎬 CineList — Catalogue de films (Flutter)

Application Flutter multi-écrans démontrant une architecture propre : séparation UI/données, navigation par routes nommées (GoRouter), state management (Riverpod), thème clair/sombre persistant, et design responsive mobile/tablette.

## Aperçu

| Liste (mobile) | Liste (tablette) | Détail | Formulaire |
|---|---|---|---|
| _screenshots/list_mobile.png_ | _screenshots/list_tablet.png_ | _screenshots/detail.png_ | _screenshots/form.png_ |

> Remplace ces liens par tes propres captures d'écran une fois l'app lancée (voir dossier `screenshots/`).

## Fonctionnalités

- ✅ 4 écrans : Liste, Détail, Formulaire, Favoris
- ✅ Navigation par routes **nommées** avec GoRouter (`/`, `/movie/:id`, `/form`, `/favorites`)
- ✅ Recherche texte + filtrage par genre sur l'écran liste
- ✅ Écran détail alimenté par un **id** passé en paramètre d'URL (compatible deep-linking)
- ✅ Formulaire avec 5 champs validés (titre, genre, réalisateur, année, durée, note)
- ✅ Thème clair/sombre, persistant entre les sessions (`shared_preferences`)
- ✅ Responsive : `ListView` sur mobile, `GridView` sur tablette (`LayoutBuilder` + breakpoint centralisé)
- ✅ Aucune donnée en dur dans les widgets : tout provient de `assets/data/movies.json` via un repository

## Architecture

```
lib/
├── main.dart                     # Point d'entrée, ProviderScope Riverpod
├── app.dart                      # MaterialApp.router, branchement thème + routeur
├── core/
│   ├── constants/breakpoints.dart   # Seuil responsive unique (600px)
│   ├── theme/
│   │   ├── app_theme.dart           # Définition des thèmes clair/sombre
│   │   └── theme_provider.dart      # State + persistance du ThemeMode
│   └── router/app_router.dart       # Toutes les routes nommées GoRouter
├── data/
│   ├── models/movie.dart            # Modèle pur (aucune dépendance Flutter)
│   ├── datasources/
│   │   └── movie_local_datasource.dart  # Lit et parse le JSON
│   └── repositories/
│       └── movie_repository.dart    # Point d'accès unique aux données
├── features/movies/
│   ├── providers/
│   │   ├── movie_providers.dart     # Chargement, recherche, filtre (Riverpod)
│   │   └── favorites_provider.dart  # Gestion des favoris
│   └── screens/
│       ├── movie_list_screen.dart
│       ├── movie_detail_screen.dart
│       ├── movie_form_screen.dart
│       └── favorites_screen.dart
└── widgets/                         # Widgets réutilisables, indépendants du modèle Movie
    ├── movie_card.dart
    ├── search_field.dart
    ├── responsive_layout.dart
    ├── empty_state.dart
    └── section_title.dart
```

**Principe de séparation appliqué** : `data/` ne connaît rien de Flutter (pas de `Widget`, pas de `BuildContext`). Les écrans (`features/*/screens`) affichent et délèguent la logique aux providers. Les widgets de `widgets/` ne connaissent jamais le modèle `Movie` — ils reçoivent des types primitifs (`String`, `double`, callbacks), ce qui les rend réellement réutilisables dans un autre contexte.

## Les 4 écrans

| Écran | Route | Rôle |
|---|---|---|
| **Liste** | `/` (name: `list`) | Affiche les films, recherche texte, filtres par genre, accès favoris et ajout |
| **Détail** | `/movie/:id` (name: `detail`) | Affiche les infos complètes d'un film récupéré par son `id` |
| **Formulaire** | `/form` (name: `form`) | Ajoute un nouveau film avec validation de 5 champs |
| **Favoris** | `/favorites` (name: `favorites`) | Liste filtrée des films marqués comme favoris |

## Widgets réutilisables (`lib/widgets/`)

- **`MovieCard`** : carte d'affichage (poster + titre + note + bouton favori), utilisée à la fois dans l'écran liste et l'écran favoris.
- **`SearchField`** : champ de recherche générique, sans logique métier.
- **`ResponsiveLayout`** : bascule `mobile`/`tablet` selon la largeur disponible (`LayoutBuilder`).
- **`EmptyState`** : état vide générique (aucun résultat, aucun favori, erreur).
- **`SectionTitle`** : titre de section standardisé pour l'écran détail.

## Choix techniques

- **GoRouter** plutôt que `Navigator` classique : routes nommées, paramètres d'URL typés, gestion propre du deep-linking, recommandé officiellement par l'équipe Flutter.
- **Riverpod** plutôt que `Provider`/`setState` : permet de composer des providers dérivés (`filteredMoviesProvider` combine recherche + filtre genre) sans dupliquer la logique dans les widgets, et reste testable sans `BuildContext`.
- **Passage d'`id` (pas d'objet complet)** entre la liste et le détail : le film est retrouvé via le repository dans l'écran détail, ce qui garde la route utilisable en deep-link direct (`/movie/m3`) sans dépendre d'un état de navigation précédent.

## Widgets Flutter utilisés (≥ 8 types différents)

`ListView`, `GridView`, `Stack`, `Card`, `Chip`/`ChoiceChip`, `Form`/`TextFormField`, `CustomScrollView`/`SliverAppBar`, `Hero`, `LayoutBuilder`, `DropdownButtonFormField`.

## Lancer le projet

Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) installé (canal stable).

```bash
git clone https://github.com/<ton-utilisateur>/cinelist.git
cd cinelist
flutter pub get
flutter run
```

Pour tester le rendu tablette sans matériel physique :

```bash
flutter emulators --launch <nom_emulateur_tablette>
# ou redimensionner la fenêtre en mode web/desktop :
flutter run -d chrome
```

Lancer les tests :

```bash
flutter test
```

## Pistes d'amélioration

- Remplacer le JSON local par un vrai appel API (seule `MovieLocalDataSource` serait à modifier, grâce à la séparation en couches).
- Persister les favoris avec `shared_preferences` ou une base locale (Hive/sqflite).
- Ajouter l'internationalisation (`flutter_localizations`).
- Ajouter des tests de widgets pour les écrans liste et formulaire.

## Structure des données (`assets/data/movies.json`)

```json
{
  "id": "m1",
  "title": "L'Écho du Silence",
  "genre": "Drame",
  "releaseYear": 2019,
  "durationMinutes": 118,
  "rating": 4.3,
  "director": "Camille Vasseur",
  "cast": ["Julien Marchand", "Lena Dubosc"],
  "posterUrl": "https://picsum.photos/seed/echo-silence/400/600",
  "synopsis": "Un pianiste devenu sourd tente de renouer avec sa fille..."
}
```

## Licence

Projet fourni à but pédagogique/démonstration — libre d'utilisation et de modification.
