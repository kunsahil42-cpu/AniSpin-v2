import 'package:go_router/go_router.dart';

import '../../features/anime_details/pages/anime_details_screen.dart';
import '../../features/favorites/pages/favorites_screen.dart';
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
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),

    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),

    GoRoute(
      path: '/anime/:id',
      builder: (context, state) {
        final animeId = int.parse(
          state.pathParameters['id']!,
        );

        return AnimeDetailsScreen(
          animeId: animeId,
        );
      },
    ),
  ],
);