import 'package:go_router/go_router.dart';

import '../../features/anime_details/pages/anime_details_screen.dart';
import '../../features/anime_roll/pages/anime_roll_screen.dart';
import '../../features/favorites/pages/favorites_screen.dart';
import '../../features/manga_details/pages/manga_details_screen.dart';
import '../../features/manga_roll/pages/manga_roll_screen.dart';
import '../../features/manga_home/pages/manga_home_screen.dart';
import '../../features/manga_reader/pages/manga_reader_screen.dart';
import '../../features/video_player/pages/video_player_screen.dart';
import '../../features/navigation/pages/main_navigation_screen.dart';
import '../../features/search/pages/search_screen.dart';
import '../../features/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationScreen(),
    ),

    GoRoute(
      path: '/anime-roll',
      builder: (context, state) => const AnimeRollScreen(),
    ),

    GoRoute(
      path: '/manga-roll',
      builder: (context, state) => const MangaRollScreen(),
    ),

    GoRoute(
      path: '/search',
      builder: (context, state) => SearchScreen(
        initialIsManga: state.uri.queryParameters['type'] == 'manga',
      ),
    ),

    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),

    GoRoute(
      path: '/manga-home',
      builder: (context, state) => const MangaHomeScreen(),
    ),

    GoRoute(
      path: '/anime/:id',
      builder: (context, state) {
        final animeId = int.parse(
          state.pathParameters['id']!,
        );
        final title = state.uri.queryParameters['title'];

        return AnimeDetailsScreen(
          animeId: animeId,
          selectedTitle: title,
        );
      },
    ),

    GoRoute(
      path: '/manga/:id',
      builder: (context, state) {
        final mangaId = int.parse(
          state.pathParameters['id']!,
        );
        final title = state.uri.queryParameters['title'];

        return MangaDetailsScreen(
          mangaId: mangaId,
          selectedTitle: title,
        );
      },
    ),

    GoRoute(
      path: '/anime/:id/play/:episode',
      builder: (context, state) {
        final animeId = int.parse(state.pathParameters['id']!);
        final episode = int.parse(state.pathParameters['episode']!);
        final extra = state.extra as Map<String, dynamic>;

        return VideoPlayerScreen(
          animeId: animeId,
          episodeNumber: episode,
          malId: extra['malId'] as int?,
          romajiTitle: extra['romajiTitle'] as String,
          englishTitle: extra['englishTitle'] as String?,
          coverImage: extra['coverImage'] as String,
          bannerImage: extra['bannerImage'] as String,
          totalEpisodes: extra['totalEpisodes'] as int,
          initialDub: extra['dub'] as bool?,
        );
      },
    ),

    GoRoute(
      path: '/manga/:id/read/:chapter',
      builder: (context, state) {
        final mangaId = int.parse(state.pathParameters['id']!);
        final chapter = state.pathParameters['chapter']!;
        final extra = state.extra as Map<String, dynamic>;

        return MangaReaderScreen(
          mangaId: mangaId,
          chapterNumber: chapter,
          chapterId: extra['chapterId'] as String?,
          romajiTitle: extra['romajiTitle'] as String,
          englishTitle: extra['englishTitle'] as String?,
          coverImage: extra['coverImage'] as String,
          bannerImage: extra['bannerImage'] as String,
          totalChapters: extra['totalChapters'] as int,
        );
      },
    ),
  ],
);