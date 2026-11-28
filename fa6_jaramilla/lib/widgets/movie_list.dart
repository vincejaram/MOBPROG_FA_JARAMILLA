import 'package:fa6_jaramilla/models/movie.dart';
import 'package:fa6_jaramilla/widgets/movie_item.dart';
import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  const MovieList({
    super.key,
    required this.movies,
    required this.removeMovie,
  });

  final List<Movie> movies;
  final void Function(Movie movie) removeMovie; 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
            margin: Theme.of(context).cardTheme.margin,
          ),
          key: ValueKey(movies[index]),
          onDismissed: (direction) {
            removeMovie(movies[index]);
          },
          child: SupplyItem(movies[index]),
        );
      },
    );
  }
}
