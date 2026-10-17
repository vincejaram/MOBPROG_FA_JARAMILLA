import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final List<Genre> genre =  [
  Genre(name: 'Fantasy', icon: Icons.local_fire_department_rounded),
  Genre(name: 'Science Fiction', icon: Icons.hub_outlined),
  Genre(name: 'Mystery', icon: Icons.lightbulb_circle_outlined),
  Genre(name: 'Horror', icon: Icons.shield_moon),
  Genre(name: 'Romance', icon: Icons.favorite_border_outlined),
  Genre(name: 'Comedy', icon: Icons.theater_comedy),
  Genre(name: 'Non-fiction', icon: Icons.face_retouching_natural),
];

enum ReadingStatus {
  toRead,
  reading,
  finished,
  didNotFinish,
}

const statusText = {
  ReadingStatus.toRead: 'To Read',
  ReadingStatus.reading: 'Reading',
  ReadingStatus.finished: 'Finished',
  ReadingStatus.didNotFinish: 'Did Not Finish',
};

class Book {
  final String id;
  final String title;
  final String author;
  final int pageCount;
  final double rating;
  final Genre genre;
  final ReadingStatus readingStatus;

  Book({
    required this.title,
    required this.author,
    required this.pageCount,
    required this.rating,
    required this.genre,
    required this.readingStatus,
  }) : id = Uuid().v4();
}

class Genre {
  final String name;
  final IconData icon;

  Genre({
    required this.name,
    required this.icon,
  });
}