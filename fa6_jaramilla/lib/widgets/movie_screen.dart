import 'package:fa6_jaramilla/data/movies.dart';
import 'package:fa6_jaramilla/models/movie.dart';
import 'package:fa6_jaramilla/widgets/login_screen.dart';
// import 'package:fa6_jaramilla/models/movie.dart';
import 'package:fa6_jaramilla/widgets/movie_list.dart';
import 'package:flutter/material.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  void openHomeScreen() {
    Navigator.of(context).pop();
  }
  
  void logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Returning false removes every route behind it
    );
  }

  void _removeMovie(Movie movie) {
    final movieIndex = movies.indexOf(movie);

    setState(() {
      movies.remove(movie);
    });

    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('Movie deleted'),
        duration: Duration(seconds: 3),
        persist: false,
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () {
            setState(() {
              movies.insert(movieIndex, movie);
            });
          })
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text(
        'No movies found',
        style: Theme.of(context).textTheme.titleMedium!
            .copyWith(fontSize: 18, color: Colors.black),
      ),
    );

    if (movies.isNotEmpty) {
      mainContent = MovieList(movies: movies, removeMovie: _removeMovie);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: openHomeScreen,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Movie Manager'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (ctx) => AlertDialog(
                title: Text('Logout confirmation',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14)),
                content: Text('Are you sure you want to logout?',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      }, 
                      child: Text('Cancel')
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        logout();
                      }, 
                      child: Text('OK')
                    ),
                    ],
              ));
            }, 
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [Expanded(child: mainContent)]),
      ),
    );
  }
}

