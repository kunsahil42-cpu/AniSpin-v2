import 'package:flutter/material.dart';

import 'anime_card.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          AnimeCard(
            title: "Attack on Titan",
            rating: "9.1",
            episodes: "89",
          ),
          SizedBox(width: 16),
          AnimeCard(
            title: "Jujutsu Kaisen",
            rating: "8.8",
            episodes: "47",
          ),
          SizedBox(width: 16),
          AnimeCard(
            title: "One Piece",
            rating: "9.0",
            episodes: "1100+",
          ),
        ],
      ),
    );
  }
}