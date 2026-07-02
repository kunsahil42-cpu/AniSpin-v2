import 'package:flutter/material.dart';

import '../models/anime_model.dart';

class AnimeTile extends StatelessWidget {
  final AnimeModel anime;

  const AnimeTile({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        anime.imageUrl,
        width: 50,
        fit: BoxFit.cover,
      ),
      title: Text(anime.title),
      subtitle: Text(
        "⭐ ${anime.score ?? '-'} | 📺 ${anime.episodes ?? '-'}",
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}