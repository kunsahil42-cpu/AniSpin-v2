import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoggerLink extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (kDebugMode) {
      debugPrint('[GraphQL Request] ${request.operation.operationName} params: ${request.variables}');
    }
    
    if (forward != null) {
      return forward(request).map((response) {
        if (kDebugMode) {
          if (response.errors != null && response.errors!.isNotEmpty) {
            debugPrint('[GraphQL Error] ${response.errors?.map((e) => e.message).join(", ")}');
          }
        }
        return response;
      });
    }
    return const Stream.empty();
  }
}

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    'https://graphql.anilist.co',
    defaultHeaders: const {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  static final Link _link = Link.from([
    LoggerLink(),
    _httpLink,
  ]);

  static GraphQLClient get client {
    return GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}