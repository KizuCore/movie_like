import 'package:flutter/material.dart';

class PosterPlaceholder extends StatelessWidget {
  final String title;
  const PosterPlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
