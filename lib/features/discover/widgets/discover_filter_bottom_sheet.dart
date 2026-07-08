import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/discover_filters.dart';
import '../providers/discover_filters_provider.dart';

class DiscoverFilterBottomSheet extends ConsumerStatefulWidget {
  const DiscoverFilterBottomSheet({super.key});

  @override
  ConsumerState<DiscoverFilterBottomSheet> createState() => _DiscoverFilterBottomSheetState();
}

class _DiscoverFilterBottomSheetState extends ConsumerState<DiscoverFilterBottomSheet> {
  late bool _isManga;
  late List<String> _selectedGenres;
  late String? _selectedSeason;
  late List<int> _selectedYears;
  late List<String> _selectedTypes;
  late List<String> _selectedStatuses;
  late List<String> _selectedLanguages;
  late List<String> _selectedRatings;
  late List<String> _selectedSources;
  late int? _minRange;
  late int? _maxRange;
  late String _selectedSortBy;

  final TextEditingController _minRangeController = TextEditingController();
  final TextEditingController _maxRangeController = TextEditingController();

  final List<String> _genres = const [
    "Action", "Adult", "Adventure", "Avant Garde", "Boys Love", "Comedy", "Crime", "Demons", "Drama", "Ecchi",
    "Fantasy", "Girls Love", "Gourmet", "Harem", "Hentai", "Historical", "Horror", "Iyashikei", "Isekai", "Josei",
    "Kids", "Magic", "Magical Girls", "Mahou Shoujo", "Martial Arts", "Mature", "Mecha", "Medical", "Military",
    "Music", "Mystery", "Parody", "Philosophical", "Police", "Psychological", "Reverse Harem", "Romance", "School",
    "Sci-Fi", "Seinen", "Shoujo", "Shoujo Ai", "Shounen", "Shounen Ai", "Slice of Life", "Smut", "Space", "Sports",
    "Super Power", "Supernatural", "Suspense", "Thriller", "Vampire", "Work Life", "Yaoi", "Yuri"
  ];

  final List<String> _seasons = const ["Winter", "Spring", "Summer", "Fall"];

  final List<int> _years = List.generate(2027 - 1960, (index) => 2026 - index);

  final List<String> _animeTypes = const ["TV", "Movie", "OVA", "ONA", "Special", "TV Special", "Music"];
  final List<String> _mangaTypes = const ["Manga", "Manhwa", "Manhua", "One Shot", "Doujinshi", "Novel", "Light Novel", "Web Manga", "Web Novel", "Comic", "Other"];

  final List<String> _animeStatuses = const ["Currently Airing", "Finished Airing", "Not Yet Aired"];
  final List<String> _mangaStatuses = const ["Publishing", "Finished", "On Hiatus", "Cancelled"];

  final List<String> _animeLanguages = const ["Sub", "Dub"];
  final List<String> _mangaLanguages = const ["Original", "English", "Auto Translated"];

  final List<String> _animeRatings = const ["G", "PG", "PG-13", "R", "R+", "Rx"];
  final List<String> _mangaRatings = const ["Everyone", "Teen", "Mature", "Adult"];

  final List<String> _animeSources = const ["Manga", "Original", "Light Novel", "Web Novel", "Novel", "Visual Novel", "Game", "Web Manga", "Comic", "Other"];
  final List<String> _mangaSources = const ["Manga", "Manhwa", "Manhua", "Original", "Novel", "Web Novel", "Other"];

  final List<String> _sortOptions = const [
    "Default", "Popularity", "Trending", "Latest Updated", "Recently Added", "Highest Rated", "Release Date", "A-Z", "Z-A"
  ];

  @override
  void initState() {
    super.initState();
    final filters = ref.read(discoverFiltersProvider);
    _isManga = filters.isManga;
    _selectedGenres = List.from(filters.genres);
    _selectedSeason = filters.season;
    _selectedYears = List.from(filters.years);
    _selectedTypes = List.from(filters.types);
    _selectedStatuses = List.from(filters.statuses);
    _selectedLanguages = List.from(filters.languages);
    _selectedRatings = List.from(filters.ratings);
    _selectedSources = List.from(filters.sources);
    _minRange = filters.minRange;
    _maxRange = filters.maxRange;
    _selectedSortBy = filters.sortBy.isEmpty ? "Default" : filters.sortBy;

    if (_minRange != null) _minRangeController.text = _minRange.toString();
    if (_maxRange != null) _maxRangeController.text = _maxRange.toString();
  }

  @override
  void dispose() {
    _minRangeController.dispose();
    _maxRangeController.dispose();
    super.dispose();
  }

  void _resetLocalFilters() {
    setState(() {
      _selectedGenres = [];
      _selectedSeason = null;
      _selectedYears = [];
      _selectedTypes = [];
      _selectedStatuses = [];
      _selectedLanguages = [];
      _selectedRatings = [];
      _selectedSources = [];
      _minRange = null;
      _maxRange = null;
      _selectedSortBy = "Default";
      _minRangeController.clear();
      _maxRangeController.clear();
    });
  }

  void _applyLocalFilters() {
    final minVal = int.tryParse(_minRangeController.text);
    final maxVal = int.tryParse(_maxRangeController.text);

    final newFilters = DiscoverFilters(
      isManga: _isManga,
      genres: _selectedGenres,
      season: _selectedSeason,
      years: _selectedYears,
      types: _selectedTypes,
      statuses: _selectedStatuses,
      languages: _selectedLanguages,
      ratings: _selectedRatings,
      sources: _selectedSources,
      minRange: minVal,
      maxRange: maxVal,
      sortBy: _selectedSortBy,
    );

    ref.read(discoverFiltersProvider.notifier).applyAll(newFilters);
    Navigator.pop(context);
  }

  int _getLocalActiveCount() {
    int count = 0;
    if (_selectedGenres.isNotEmpty) count += _selectedGenres.length;
    if (_selectedSeason != null) count += 1;
    if (_selectedYears.isNotEmpty) count += _selectedYears.length;
    if (_selectedTypes.isNotEmpty) count += _selectedTypes.length;
    if (_selectedStatuses.isNotEmpty) count += _selectedStatuses.length;
    if (_selectedLanguages.isNotEmpty) count += _selectedLanguages.length;
    if (_selectedRatings.isNotEmpty) count += _selectedRatings.length;
    if (_selectedSources.isNotEmpty) count += _selectedSources.length;
    if (int.tryParse(_minRangeController.text) != null) count += 1;
    if (int.tryParse(_maxRangeController.text) != null) count += 1;
    if (_selectedSortBy != "Default" && _selectedSortBy.isNotEmpty) count += 1;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = _getLocalActiveCount();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Filters",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (activeCount > 0) ...[
                      const SizedBox(width: 8),
                      Badge.count(
                        count: activeCount,
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: _resetLocalFilters,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ),
          const Divider(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tab Switcher for Anime/Manga
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text("Anime"),
                        icon: Icon(Icons.movie_filter_rounded),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text("Manga"),
                        icon: Icon(Icons.book_rounded),
                      ),
                    ],
                    selected: {_isManga},
                    onSelectionChanged: (Set<bool> selection) {
                      setState(() {
                        _isManga = selection.first;
                        // Reset types/statuses/ratings when switching to avoid mismatch
                        _selectedTypes = [];
                        _selectedStatuses = [];
                        _selectedRatings = [];
                        _selectedLanguages = [];
                        _selectedSources = [];
                      });
                    },
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: theme.colorScheme.primaryContainer,
                      selectedForegroundColor: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 1. Genres
                  _buildExpansionSection(
                    title: "Genre",
                    icon: Icons.category_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _genres.map((genre) {
                        final isSelected = _selectedGenres.contains(genre);
                        return FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGenres.add(genre);
                              } else {
                                _selectedGenres.remove(genre);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 2. Season
                  if (!_isManga) ...[
                    _buildExpansionSection(
                      title: "Season",
                      icon: Icons.cloud_rounded,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _seasons.map((season) {
                          final isSelected = _selectedSeason == season;
                          return ChoiceChip(
                            label: Text(season),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedSeason = selected ? season : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // 3. Year
                  _buildExpansionSection(
                    title: "Year",
                    icon: Icons.calendar_month_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _years.map((year) {
                        final isSelected = _selectedYears.contains(year);
                        return FilterChip(
                          label: Text(year.toString()),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedYears.add(year);
                              } else {
                                _selectedYears.remove(year);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 4. Type (Format)
                  _buildExpansionSection(
                    title: "Type",
                    icon: Icons.format_shapes_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_isManga ? _mangaTypes : _animeTypes).map((type) {
                        final isSelected = _selectedTypes.contains(type);
                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTypes.add(type);
                              } else {
                                _selectedTypes.remove(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 5. Status
                  _buildExpansionSection(
                    title: "Status",
                    icon: Icons.info_outline_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_isManga ? _mangaStatuses : _animeStatuses).map((status) {
                        final isSelected = _selectedStatuses.contains(status);
                        return FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedStatuses.add(status);
                              } else {
                                _selectedStatuses.remove(status);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 6. Language
                  _buildExpansionSection(
                    title: "Language",
                    icon: Icons.language_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_isManga ? _mangaLanguages : _animeLanguages).map((lang) {
                        final isSelected = _selectedLanguages.contains(lang);
                        return FilterChip(
                          label: Text(lang),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedLanguages.add(lang);
                              } else {
                                _selectedLanguages.remove(lang);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 7. Rating
                  _buildExpansionSection(
                    title: "Rating",
                    icon: Icons.rate_review_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_isManga ? _mangaRatings : _animeRatings).map((rating) {
                        final isSelected = _selectedRatings.contains(rating);
                        return FilterChip(
                          label: Text(rating),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedRatings.add(rating);
                              } else {
                                _selectedRatings.remove(rating);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 8. Source
                  _buildExpansionSection(
                    title: "Source",
                    icon: Icons.source_rounded,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_isManga ? _mangaSources : _animeSources).map((src) {
                        final isSelected = _selectedSources.contains(src);
                        return FilterChip(
                          label: Text(src),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSources.add(src);
                              } else {
                                _selectedSources.remove(src);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // 9. Episode / Chapter Range
                  _buildExpansionSection(
                    title: _isManga ? "Chapter Range" : "Episode Range",
                    icon: Icons.onetwothree_rounded,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minRangeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: "Min",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text("to"),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _maxRangeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: "Max",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 10. Sort By
                  _buildExpansionSection(
                    title: "Sort By",
                    icon: Icons.sort_rounded,
                    isInitiallyExpanded: true,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((opt) {
                        final isSelected = _selectedSortBy == opt;
                        return ChoiceChip(
                          label: Text(opt),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSortBy = opt;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Actions Button Row
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _applyLocalFilters,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionSection({
    required String title,
    required IconData icon,
    required Widget child,
    bool isInitiallyExpanded = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isInitiallyExpanded,
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [child],
        ),
      ),
    );
  }
}
