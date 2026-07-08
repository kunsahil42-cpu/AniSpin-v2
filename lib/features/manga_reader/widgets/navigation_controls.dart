import 'package:flutter/material.dart';

class NavigationControls extends StatelessWidget {
  final int currentChapter;
  final int totalChapters;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationControls({
    super.key,
    required this.currentChapter,
    required this.totalChapters,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: currentChapter > 1 ? onPrevious : null,
          tooltip: 'Previous Chapter',
        ),
        Text(
          'Ch. $currentChapter',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: currentChapter < totalChapters ? onNext : null,
          tooltip: 'Next Chapter',
        ),
      ],
    );
  }
}
