import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'graphql_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  void _login() async {
    const String loginMutation = """
      mutation LoginMutation(
        \$username: String!
        \$password: String!
      ) {
        tokenAuth(username: \$username, password: \$password) {
          token
        }
      }
    """;

    final MutationOptions options = MutationOptions(
      document: gql(loginMutation),
      variables: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    final result = await client.value.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return;
    }

    final data = result.data;
    if (data == null || data['tokenAuth'] == null) {
      print('Login failed: no data returned');
      return;
    }

    final token = data['tokenAuth']['token'];
    if (token == null) {
      print('Login failed: no token returned');
      return;
    }

    await storage.write(key: 'token', value: token);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
