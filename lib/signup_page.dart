import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
      return;
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: _signup, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
