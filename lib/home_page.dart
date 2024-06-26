import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String fetchLinksQuery = """
      query {
        links {
          id
          answer
          link
          postedBy {
            username
          }
          votes {
            id
          }
        }
      }
    """;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(fetchLinksQuery),
        ),
        builder: (QueryResult result, { Future<QueryResult<Object?>> Function(FetchMoreOptions)? fetchMore, Future<QueryResult<Object?>?> Function()? refetch }) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          List? links = result.data?['links'] as List?;
          if (links == null || links.isEmpty) {
            return Center(child: Text('No links available.'));
          }

          return ListView.builder(
            itemCount: links.length,
            itemBuilder: (context, index) {
              final link = links[index];
              final username = link['postedBy']?['username'] ?? 'Anonymous'; // Provide default value

              // Check if the link is a valid URL from Firebase Storage
              bool isFirebaseStorageLink = link['link'] != null && link['link'].startsWith('https://firebasestorage.googleapis.com');

              return ListTile(
                title: Text(link['answer'] ?? ''),
                subtitle: isFirebaseStorageLink
                    ? Image.network(link['link'])
                    : Text(link['link'] ?? ''), // Render image if link is a valid Firebase Storage URL
                trailing: Text(username),
              );
            },
          );
        },
      ),
    );
  }
}
