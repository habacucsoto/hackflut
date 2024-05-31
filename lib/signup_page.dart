import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hackflut/graphql_config.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signup() async {
    const String signupMutation = """
      mutation SignupMutation(
        \$email: String!
        \$username: String!
        \$password: String!
      ) {
        createUser(
          email: \$email,
          username: \$username,
          password: \$password
        ) {
          user {
            id
            username
            email
          }
        }
      }
    """;

    final MutationOptions options = MutationOptions(
      document: gql(signupMutation),
      variables: {
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    final result = await client.value.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result.exception.toString()}')),
      );
      return;
    }

    final user = result.data?['createUser']['user'];
    if (user != null) {
      _login();
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result.exception.toString()}')),
      );
      return;
    }

    final token = result.data?['tokenAuth']['token'];
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
