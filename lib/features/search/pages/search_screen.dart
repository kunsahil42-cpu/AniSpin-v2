import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/states/empty_state.dart';
import '../providers/search_provider.dart';
import '../widgets/anime_tile.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search_field.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends ConsumerState<SearchScreen> {
  final TextEditingController _controller =
      TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(
      animeSearchProvider(_query),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Anime"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchField(
            controller: _controller,
            onChanged: () {
              setState(() {
                _query = _controller.text;
              });
            },
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? const EmptyWidget()
                : searchResult.when(
                    loading: () =>
                        const LoadingWidget(),
                    error: (error, stackTrace) =>
                        SearchErrorWidget(
                      message: error.toString(),
                    ),
                    data: (animeList) {
                      if (animeList.isEmpty) {
                        return const EmptyState(
                          title: "No Anime Found",
                          subtitle:
                              "Try searching with a different keyword.",
                          icon:
                              Icons.search_off_rounded,
                        );
                      }

                      return ListView.builder(
                        itemCount: animeList.length,
                        itemBuilder:
                            (context, index) {
                          return AnimeTile(
                            anime:
                                animeList[index],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}