import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    'https://graphql.anilist.co',
  );

  static GraphQLClient get client {
    return GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(),
    );
  }
}