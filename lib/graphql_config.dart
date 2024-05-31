import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart'; // Importar ValueNotifier

late ValueNotifier<GraphQLClient> client;

Future<void> initGraphQLClient() async {
  final HttpLink httpLink = HttpLink(
    'http://127.0.0.1:8000/graphql/',
  );

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final String? token = await secureStorage.read(key: 'token');

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $token',
  );

  final Link link = authLink.concat(httpLink);

  client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}
