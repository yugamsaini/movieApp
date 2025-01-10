import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name']),
      ),
      body: Column(
        children: [
          Image.network(movie['image']?['original'] ?? ''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
