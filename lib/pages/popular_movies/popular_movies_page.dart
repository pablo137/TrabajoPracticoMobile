import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabajo_practico/pages/login/login_page.dart';

class PopularMoviesPage extends StatefulWidget {
  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  final String apiKey = '0822a17859a3e05052902238b018e409';
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchPopularMovies();
  }

  Future<void> fetchPopularMovies() async {
    final url = Uri.https(
      'api.themoviedb.org',
      '/3/movie/popular',
      {'api_key': apiKey},
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        movies = responseData['results'];
      });
    } else {
      print('Failed to load popular movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            leading: movie['poster_path'] != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.movie),
            title: Text(movie['title']),
            subtitle: Text(movie['overview']),
          );
        },
      ),
    );
  }

  void _signOut() async {
    // Remove authentication state
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    // Navigate to login screen or any other desired screen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
