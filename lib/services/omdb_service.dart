import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class OmdbService {
  final String apiKey;
  OmdbService({required this.apiKey});

  // Service pour rechercher des films par titre, année, page et type
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
    String type = 'movie', //Mettre film par défaut
  }) async {
    final uri = Uri.http('www.omdbapi.com', '/', {
      's': query, // Permet de récupérer une liste de films
      'apikey': apiKey,
      'type': type,
      'page': '$page',
    });
    final res = await http.get(uri);

    // Gérer les erreurs HTTP
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }

    // Décoder la réponse JSON de l'API en une Map<String, dynamic>
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    // Vérifier si l'API indique que la recherche est valide
    // OMDb renvoie "Response": "True" si des résultats sont trouvés
    if (data['Response'] != 'True') return <Movie>[];

    // Récupérer la liste brute des films sous la clé "Search"
    // On cast en List<Map<String, dynamic>> pour manipuler plus facilement
    final list = (data['Search'] as List).cast<Map<String, dynamic>>();

  // Transformer chaque élément JSON de la liste en un objet Movie
  // grâce au constructeur factory Movie.fromOmdb, puis retourner la liste
    return list.map(Movie.fromOmdb).toList();

  }
  // Service pour récupérer les détails d'un film par son ID IMDb
  Future<Movie?> getById(String imdbID) async {
    final uri = Uri.http('www.omdbapi.com', '/', {
      'i': imdbID,
      'apikey': apiKey,
      'plot': 'short',
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['Response'] != 'True') return null;
    return Movie.fromOmdb(data);
  }

}
