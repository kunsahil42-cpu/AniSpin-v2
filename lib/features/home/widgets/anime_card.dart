import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final String title;
  final String rating;
  final String episodes;

  const AnimeCard({
    super.key,
    required this.title,
    required this.rating,
    required this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              color: Colors.deepPurple,
              child: const Center(
                child: Icon(
                  Icons.movie,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("⭐ $rating"),
                  Text("$episodes Episodes"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}