import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List movies = [];
  String searchTerm = '';

  searchMovies(String term) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$term'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
                searchMovies(value);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index]['show'];
                return ListTile(
                  leading: Image.network(movie['image']?['medium'] ?? ''),
                  title: Text(movie['name']),
                  subtitle: Text(movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? ''),
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: movie);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
