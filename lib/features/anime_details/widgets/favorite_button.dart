import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../favorites/models/favorite_anime.dart';
import '../../favorites/providers/favorites_provider.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final int animeId;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String? bannerImage;
  final int? averageScore;
  final int? episodes;
  final String? status;
  final String? studio;
  final String? season;
  final int? seasonYear;

  const FavoriteButton({
    super.key,
    required this.animeId,
    required this.romajiTitle,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.averageScore,
    required this.episodes,
    required this.status,
    required this.studio,
    required this.season,
    required this.seasonYear,
  });

  @override
  ConsumerState<FavoriteButton> createState() =>
      _FavoriteButtonState();
}

class _FavoriteButtonState
    extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _scale = Tween<double>(
      begin: 1,
      end: 1.25,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle(bool isFavorite) async {
    final repository = ref.read(
      favoritesRepositoryProvider,
    );

    final anime = FavoriteAnime()
      ..animeId = widget.animeId
      ..romajiTitle = widget.romajiTitle
      ..englishTitle = widget.englishTitle
      ..coverImage = widget.coverImage
      ..bannerImage = widget.bannerImage
      ..averageScore = widget.averageScore
      ..episodes = widget.episodes
      ..status = widget.status
      ..studio = widget.studio
      ..season = widget.season
      ..seasonYear = widget.seasonYear;

    await repository.toggleFavorite(anime);

    _controller.forward().then((_) {
      _controller.reverse();
    });

    ref.invalidate(
      isFavoriteProvider(widget.animeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorite = ref.watch(
      isFavoriteProvider(widget.animeId),
    );

    return favorite.when(
      loading: () =>  FilledButton.icon(
        onPressed: null,
        icon: Icon(Icons.favorite_border_rounded),
        label: Text("Favorite"),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (isFavorite) {
        return ScaleTransition(
          scale: _scale,
          child: FilledButton.icon(
            onPressed: () => _toggle(isFavorite),
            icon: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 250,
              ),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey(isFavorite),
              ),
            ),
            label: Text(
              isFavorite
                  ? "Saved"
                  : "Favorite",
            ),
          ),
        );
      },
    );
  }
}