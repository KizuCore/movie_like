import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'poster_placeholder.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool selected;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: selected ? 3 : 1,
            color: selected ? Colors.indigo : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [BoxShadow(blurRadius: 6, spreadRadius: 1, color: Colors.black12)]
              : [],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: (movie.poster != null && movie.poster != 'N/A')
                    ? Image.network(
                  movie.poster!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => PosterPlaceholder(title: movie.title),
                )
                    : PosterPlaceholder(title: movie.title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Text(movie.year ?? '', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  const Spacer(),
                  Icon(
                    selected ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: selected ? Colors.indigo : Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
