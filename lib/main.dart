import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'create_link_page.dart';
import 'signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGraphQLClient(); // Asegurarnos de que el cliente está inicializado antes de correr la app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'GraphQL Flutter App',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/create': (context) => CreateLinkPage(),
          '/signup': (context) => SignupPage(),
        },
      ),
    );
  }
}
