import 'package:fa6_jaramilla/models/movie.dart';
import 'package:flutter/material.dart';

class SupplyItem extends StatelessWidget {
  final Movie movie;

  const SupplyItem(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: (MediaQuery.sizeOf(context).height) * 0.22,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      movie.name,
                      style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Year Released: ${movie.year}',
                    style: Theme.of(context).textTheme.titleSmall!
                        .copyWith(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Rating: ${movie.rating}/10',
                    style: Theme.of(context).textTheme.titleMedium!
                        .copyWith(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
