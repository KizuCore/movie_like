class Movie {
  final String imdbID;
  final String title;
  final String? year;
  final String? poster;

  Movie({
    required this.imdbID,
    required this.title,
    this.year,
    this.poster,
  });

  factory Movie.fromOmdb(Map<String, dynamic> json) => Movie(
    imdbID: json['imdbID'] as String,
    title: json['Title'] as String,
    year: json['Year'] as String?,
    poster: json['Poster'] as String?,
  );
}
