import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.03;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Netflix',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: size.width * 0.08,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Trending Now', size),
              buildMovieCarousel(size),
              buildSectionTitle('Popular on Netflix', size),
              buildMovieGrid(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildMovieCarousel(Size size) {
    final imageHeight = size.height * 0.25;
    final imageWidth = size.width * 0.3;

    return Container(
      height: imageHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index]['show'];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: movie);
            },
            child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.03),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie['image']?['medium'] ??
                      'https://via.placeholder.com/100x150.png?text=No+Image',
                  fit: BoxFit.cover,
                  width: imageWidth,
                  height: imageHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'lib/assets/images/movieIcon.png',
                      fit: BoxFit.cover,
                      width: imageWidth,
                      height: imageHeight,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMovieGrid(Size size) {
    final crossAxisCount = size.width > 600 ? 4 : 3;

    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: size.width * 0.02,
          mainAxisSpacing: size.height * 0.02,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index]['show'];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: movie);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                movie['image']?['medium'] ??
                    'https://via.placeholder.com/100x150.png?text=No+Image',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/assets/images/movieIcon.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
