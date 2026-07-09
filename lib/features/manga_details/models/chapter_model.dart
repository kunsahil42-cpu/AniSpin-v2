class ChapterModel {
  final String? id;
  final int number;
  final String title;
  final String scanGroup;
  final String date;
  final String language;
  final List<String> pages;
  final bool isAutoTranslate;
  final bool isColored;
  final bool isExternal;
  final String? externalUrl;
  final List<ChapterModel> alternatives;
  final String source;

  ChapterModel({
    this.id,
    required this.number,
    required this.title,
    required this.scanGroup,
    required this.date,
    required this.language,
    required this.pages,
    this.isAutoTranslate = false,
    this.isColored = false,
    this.isExternal = false,
    this.externalUrl,
    this.alternatives = const [],
    this.source = 'mangadex',
  });

  factory ChapterModel.mock(int mangaId, int chapterNumber) {
    // Generate mock manga page URLs
    // Stable high-quality public sample illustrations
    final pageUrls = List.generate(12, (index) {
      final id = (mangaId + chapterNumber + index) % 10 + 1;
      return 'https://picsum.photos/id/${10 + id * 5}/800/1200';
    });

    return ChapterModel(
      id: null,
      number: chapterNumber,
      title: 'Chapter $chapterNumber: An Unexpected Journey',
      scanGroup: 'Aurora Scanlations',
      date: 'July ${2 + chapterNumber}, 2026',
      language: 'EN',
      pages: pageUrls,
      isAutoTranslate: false,
      isColored: false,
      isExternal: false,
      externalUrl: null,
      alternatives: const [],
      source: 'mangadex',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'scanGroup': scanGroup,
      'date': date,
      'language': language,
      'pages': pages,
      'isAutoTranslate': isAutoTranslate,
      'isColored': isColored,
      'isExternal': isExternal,
      'externalUrl': externalUrl,
      'alternatives': alternatives.map((c) => c.toJson()).toList(),
      'source': source,
    };
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String?,
      number: json['number'] as int,
      title: json['title'] as String? ?? '',
      scanGroup: json['scanGroup'] as String? ?? '',
      date: json['date'] as String? ?? '',
      language: json['language'] as String? ?? '',
      pages: List<String>.from(json['pages'] as Iterable? ?? const []),
      isAutoTranslate: json['isAutoTranslate'] as bool? ?? false,
      isColored: json['isColored'] as bool? ?? false,
      isExternal: json['isExternal'] as bool? ?? false,
      externalUrl: json['externalUrl'] as String?,
      alternatives: (json['alternatives'] as List?)
              ?.map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      source: json['source'] as String? ?? 'mangadex',
    );
  }
}
