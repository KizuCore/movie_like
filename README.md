# Movies Likes (OMDb)

Application Flutter permettant de **rechercher des films via l’API OMDb**, de **liker/déliker** des films (bordure + cœur), de **compter** les favoris dans l’AppBar, et de **persister** les likes en local avec `SharedPreferences`.  
Une page **Favoris** affiche uniquement les films likés.

> ⚠️ OMDb **ne fournit pas** d’endpoint “Now Playing / Actuellement à l’affiche”. On simule un écran d’accueil “cette année” via une recherche large + filtre d’année.

---

## Fonctionnalités

- 🔎 **Recherche** de films par mot-clé (titre, extrait…)
- 🖼️ **Affichage en grille** (poster + titre + année)
- ❤️ **Like/Unlike** d’un film par tap (bordure colorée + icône favorite)
- 🔢 **Compteur** de favoris dans l’AppBar
- 💾 **Persistance locale** des favoris (IDs IMDb) via `SharedPreferences`
- ⭐ **Page Favoris** listant les films likés (tap = retirer des favoris)

---

## Prérequis

- Flutter 3.x+
- Dart 3.x+
- Une clé API OMDb → https://www.omdbapi.com/apikey.aspx (gratuite/limitée)
- Accès internet (Android : `android.permission.INTERNET`, déjà ajouté par défaut dans un projet Flutter récent)

---

## Démarrage

1. **Cloner** le projet, puis installer les dépendances :
   ```bash
   flutter pub get
   ```

2. **Lancer le projet** :
    ```bash
    flutter run 
    ```


---

## Structure du projet

```
lib/
├─ main.dart                    # Entrée de l’application
├─ models/
│  └─ movie.dart               # Modèle Movie
├─ services/
│  └─ omdb_service.dart        # Appels HTTP à l’API OMDb (search, getById)
├─ repositories/
│  └─ likes_repository.dart    # Persistance locale des IDs likés (SharedPreferences)
├─ widgets/
│  ├─ movie_card.dart          # Carte film (poster, titre, affichage like)
│  └─ poster_placeholder.dart  # Placeholder si pas de poster
└─ pages/
   ├─ home_page.dart           # Page principale (recherche, grid)
   └─ favorites_page.dart      # Page Favoris (films likés)
```

---

## Configuration & Dépendances

`pubspec.yaml` (extrait) :
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.5.0
  shared_preferences: ^2.3.2
```

---

## Utilisation de l’API OMDb

### Recherche
- Endpoint : `/?s=<query>&type=movie&page=1&apikey=<KEY>`
- Réponse : `{ "Search": [ { "Title": "...", "Year": "...", "imdbID": "...", "Poster": "..." } ], "Response": "True" }`

Dans `OmdbService.searchMovies(...)` :
- Construit l’URL avec `Uri.http('www.omdbapi.com', '/', {...})`
- `http.get(...)`
- `jsonDecode(...)`
- Mappe `Search` → `List<Movie>`

### Détails par ID
- Endpoint : `/?i=<imdbID>&plot=short&apikey=<KEY>`
- Utile pour la page **Favoris** (récupérer titre/poster à partir d’un ID persistant).

---

## Pages clés

### HomePage
- Input de recherche + bouton
- Grid des résultats
- Bouton cœur (AppBar) → **FavoritesPage** (en haut à droite)

### FavoritesPage
- Charge la liste des IDs likés depuis `LikesRepository`
- Pour chaque ID → `OmdbService.getById(...)`
- Affiche une grille de films (tous **sélectionnés**)
- Tap sur une carte = **retirer** des favoris (mise à jour immédiate + persistance)

---

## Limitations & Choix techniques

- **OMDb ne propose pas “Now Playing”** : on **simule “cette année”** avec une requête large (ex. `query='a'`) + paramètre `y=année courante`. Résultat : *“releases de l’année” approximatives*, pas la vraie “affiche du moment”.
- **Pagination OMDb** : 10 résultats par page. La page d’accueil utilise `page=1`.

---


## Licence

Projet pédagogique
OMDb © Open Movie Database – usage soumis à leurs conditions.
