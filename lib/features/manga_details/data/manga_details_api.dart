import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/manga_details_queries.dart';

class MangaDetailsApi {
  Future<QueryResult> getMangaDetails(int id) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          MangaDetailsQueries.getMangaDetails,
        ),
        variables: {
          'id': id,
        },
      ),
    );
  }
}