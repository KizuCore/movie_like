import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repositories/likes_repository.dart';
import '../services/omdb_service.dart';
import '../widgets/movie_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _likesRepo = LikesRepository();
  late final OmdbService _omdb;

  Set<String> _liked = {};
  List<Movie> _movies = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _omdb = OmdbService(apiKey: 'e205f1d6'); // la clé API OMDb
    _bootstrap();
  }

  // Charger les films likés au démarrage
  Future<void> _bootstrap() async {
    try {
      _liked = await _likesRepo.load();
      // Charger les détails en parallèle (Future.wait)
      final details = await Future.wait(_liked.map((id) => _omdb.getById(id)));
      _movies = details.whereType<Movie>().toList();
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Retirer un film des favoris
  Future<void> _toggleUnlike(Movie m) async {
    setState(() {
      _liked.remove(m.imdbID);
      _movies.removeWhere((mm) => mm.imdbID == m.imdbID);
    });
    await _likesRepo.save(_liked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes favoris (${_liked.length} ♥)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : _movies.isEmpty
          ? const Center(child: Text('Aucun film liké pour le moment.'))
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
          return MovieCard(
            movie: m,
            selected: true, // sur favoris: déjà liké
            onTap: () => _toggleUnlike(m), // tap = retirer des favoris
          );
        },
      ),
    );
  }
}
