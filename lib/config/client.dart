import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';

class APIClient {
  ValueNotifier<GraphQLClient> getAPIClient() {
    final HttpLink httpLink = HttpLink(
      '${dotenv.env['BACKEND_URL']}',
    );

    final WebSocketLink webSocketLink = WebSocketLink(
      '${dotenv.env['BACKEND_WEB_SOCKET_URL']}',
    );

    String? token;

    final AuthLink authLink = AuthLink(
      getToken: () async {
        token = await APIUtils().getToken();

        return token != null ? 'Bearer $token' : null;
      },
    );

    final Link link = authLink.concat(httpLink).concat(webSocketLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return client;
  }
}
