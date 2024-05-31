import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hackflut/graphql_config.dart';

class CreateLinkPage extends StatefulWidget {
  @override
  _CreateLinkPageState createState() => _CreateLinkPageState();
}

class _CreateLinkPageState extends State<CreateLinkPage> {
  final _answerController = TextEditingController();
  final _linkController = TextEditingController();

  void _createLink() async {
    const String createLinkMutation = """
      mutation PostMutation(\$answer: String!, \$link: String!) {
        createLink(answer: \$answer, link: \$link) {
          id
          answer
          link
        }
      }
    """;

    final MutationOptions options = MutationOptions(
      document: gql(createLinkMutation),
      variables: {
        'answer': _answerController.text,
        'link': _linkController.text,
      },
    );

    final result = await client.value.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      // Mostrar un mensaje de error al usuario si es necesario
      return;
    }

    // Mostrar un mensaje de éxito al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link creado exitosamente'),
        duration: Duration(seconds: 2),
      ),
    );

    // Opcional: esperar un momento y luego cerrar la página
    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.pop(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Link')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _answerController, decoration: InputDecoration(labelText: 'Answer')),
            TextField(controller: _linkController, decoration: InputDecoration(labelText: 'Link')),
            ElevatedButton(onPressed: _createLink, child: Text('Create')),
          ],
        ),
      ),
    );
  }
}
