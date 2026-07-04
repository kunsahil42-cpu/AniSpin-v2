import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../favorites/models/favorite_manga.dart';
import '../../favorites/providers/favorites_provider.dart';

class MangaFavoriteButton extends ConsumerStatefulWidget {
  final int mangaId;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String? bannerImage;
  final int? chapters;
  final int? volumes;
  final String? status;
  final String? author;

  const MangaFavoriteButton({
    super.key,
    required this.mangaId,
    required this.romajiTitle,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.chapters,
    required this.volumes,
    required this.status,
    required this.author,
  });

  @override
  ConsumerState<MangaFavoriteButton> createState() =>
      _MangaFavoriteButtonState();
}

class _MangaFavoriteButtonState
    extends ConsumerState<MangaFavoriteButton>
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

    final manga = FavoriteManga()
      ..mangaId = widget.mangaId
      ..romajiTitle = widget.romajiTitle
      ..englishTitle = widget.englishTitle
      ..coverImage = widget.coverImage
      ..bannerImage = widget.bannerImage
      ..chapters = widget.chapters
      ..volumes = widget.volumes
      ..status = widget.status
      ..author = widget.author;

    await repository.toggleMangaFavorite(
      manga,
    );

    await _controller.forward();
    await _controller.reverse();

    ref.invalidate(
      isMangaFavoriteProvider(
        widget.mangaId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorite = ref.watch(
      isMangaFavoriteProvider(
        widget.mangaId,
      ),
    );

    return favorite.when(
      loading: () => FilledButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.favorite_border_rounded,
        ),
        label: const Text(
          "Favorite",
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (isFavorite) {
        return ScaleTransition(
          scale: _scale,
          child: FilledButton.icon(
            onPressed: () =>
                _toggle(isFavorite),
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
                key: ValueKey(
                  isFavorite,
                ),
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