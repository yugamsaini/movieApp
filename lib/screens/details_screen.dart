import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final movie = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          movie['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.06, // Dynamic font size
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              movie['image']?['original'] ??
                  'https://via.placeholder.com/200x300.png?text=No+Image',
              fit: BoxFit.cover,
              height: size.height * 0.4, // Dynamic height
              width: size.width,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'lib/assets/images/movieIcon.png',
                  fit: BoxFit.cover,
                  height: size.height * 0.4,
                  width: size.width,
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.05), // Dynamic padding
              child: Text(
                movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
                style: TextStyle(
                  fontSize: size.width * 0.045, // Dynamic font size
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
