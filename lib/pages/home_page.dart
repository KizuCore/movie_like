import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/omdb_service.dart';
import '../repositories/likes_repository.dart';
import '../widgets/movie_card.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController(); // Contrôleur pour le champ de recherche
  late final OmdbService _omdb; // Service OMDb
  final _likesRepo = LikesRepository(); // Référentiel pour gérer les likes

  List<Movie> _movies = [];
  Set<String> _liked = {};
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _omdb = OmdbService(apiKey: 'e205f1d6'); // la clé API OMDb
    _bootstrap();
  }

  // Initialiser l'état en chargeant les films likés
  Future<void> _bootstrap() async {
    await _loadLikes();
  }

  // Charger les films likés depuis le référentiel
  Future<void> _loadLikes() async {
    _liked = await _likesRepo.load();
    if (mounted) setState(() {});
  }

  // Sauvegarder les films likés dans le référentiel
  Future<void> _saveLikes() => _likesRepo.save(_liked);

  // Rechercher des films via OMDb
  Future<void> _search() async {
    final q = _searchCtrl.text.trim(); // Nettoyer la requête
    if (q.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Rechercher des films avec la requête
      final results = await _omdb.searchMovies(query: q, page: 1);
      setState(() => _movies = results);
    } catch (e) {
      setState(() => _error = 'Erreur: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Mettre à jour la liste des films likés
  void _toggleLike(Movie m) {
    setState(() {
      // Si déjà liké, le retirer, sinon l'ajouter
      _liked.contains(m.imdbID) ? _liked.remove(m.imdbID) : _liked.add(m.imdbID);
    });
    _saveLikes();
  }

  @override
  Widget build(BuildContext context) {
    final likedCount = _liked.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Films (${likedCount} ♥)'),
        actions: [
          IconButton(
            tooltip: 'Voir mes favoris',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un film… (OMDb)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                  label: const Text('Chercher'),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: _movies.isEmpty
                  ? const Center(child: Text('Aucun résultat'))
                  : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.6,
                ),
                itemCount: _movies.length,
                itemBuilder: (context, i) {
                  final m = _movies[i];
                  final selected = _liked.contains(m.imdbID);
                  return MovieCard(
                    movie: m,
                    selected: selected,
                    onTap: () => _toggleLike(m),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
