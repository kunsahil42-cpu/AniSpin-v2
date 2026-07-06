import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/translation_cache.dart';

enum OcrTranslationStatus {
  idle,
  extractingText, // OCR stage
  translating,    // Translation stage
  completed,
  failed,
}

class OcrTranslationState {
  final OcrTranslationStatus status;
  final double progress;
  final String message;

  OcrTranslationState({
    required this.status,
    required this.progress,
    required this.message,
  });

  OcrTranslationState.initial()
      : status = OcrTranslationStatus.idle,
        progress = 0.0,
        message = '';

  OcrTranslationState copyWith({
    OcrTranslationStatus? status,
    double? progress,
    String? message,
  }) {
    return OcrTranslationState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

class OcrTranslationNotifier extends FamilyNotifier<OcrTranslationState, String> {
  @override
  OcrTranslationState build(String chapterId) {
    return OcrTranslationState.initial();
  }

  Future<void> startPipeline() async {
    if (state.status != OcrTranslationStatus.idle) return;

    // Check if translation is already cached locally
    final cached = await TranslationCache().get(arg);
    if (cached != null) {
      state = OcrTranslationState(
        status: OcrTranslationStatus.completed,
        progress: 1.0,
        message: 'Translation loaded from local cache.',
      );
      return;
    }

    state = OcrTranslationState(
      status: OcrTranslationStatus.extractingText,
      progress: 0.1,
      message: 'Initializing OCR engine...',
    );

    // Simulate OCR progress
    Timer(const Duration(milliseconds: 800), () {
      if (!state.status.isRunning) return;
      state = state.copyWith(
        progress: 0.4,
        message: 'Extracting source text from pages...',
      );
    });

    // Simulate Translation progress
    Timer(const Duration(milliseconds: 1800), () {
      if (!state.status.isRunning) return;
      state = state.copyWith(
        status: OcrTranslationStatus.translating,
        progress: 0.7,
        message: 'Translating text to English...',
      );
    });

    // Simulate completion
    Timer(const Duration(milliseconds: 3000), () {
      if (!state.status.isRunning) return;
      state = state.copyWith(
        status: OcrTranslationStatus.completed,
        progress: 1.0,
        message: 'Translation completed successfully.',
      );
    });
  }

  void reset() {
    state = OcrTranslationState.initial();
  }
}

extension OcrTranslationStatusX on OcrTranslationStatus {
  bool get isRunning =>
      this == OcrTranslationStatus.extractingText ||
      this == OcrTranslationStatus.translating;
}

final ocrTranslationPipelineProvider =
    NotifierProvider.family<OcrTranslationNotifier, OcrTranslationState, String>(
  OcrTranslationNotifier.new,
);
