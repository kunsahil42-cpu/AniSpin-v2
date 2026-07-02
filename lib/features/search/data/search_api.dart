import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/anime_queries.dart';

class SearchApi {
  Future<QueryResult> searchAnime(String search) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(AnimeQueries.searchAnime),
        variables: {
          'search': search,
        },
      ),
    );
  }
}