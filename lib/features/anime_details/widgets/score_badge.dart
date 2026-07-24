import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int? score;

  const ScoreBadge({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final hasScore = score != null && score! > 0;
    final scoreText = hasScore ? (score! / 10).toStringAsFixed(1) : "Not Rated";

    return Chip(
      avatar: const Icon(
        Icons.star,
        color: Colors.amber,
        size: 18,
      ),
      label: Text(
        scoreText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.amber.withValues(alpha: 0.15),
    );
  }
}