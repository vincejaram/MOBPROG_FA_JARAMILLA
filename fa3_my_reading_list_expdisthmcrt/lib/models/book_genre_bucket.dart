import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';

class BookGenreBucket {
  const BookGenreBucket({
    required this.genre,
    required this.books,
  });

  final Genre genre;
  final List<Book> books;

  BookGenreBucket.forGenre(List<Book> allBooks, this.genre)
    : books = allBooks
      .where((book) => book.genre == genre)
      .toList();
}