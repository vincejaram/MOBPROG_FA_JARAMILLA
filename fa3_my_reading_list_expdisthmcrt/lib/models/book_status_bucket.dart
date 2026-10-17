import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';

class BookStatusBucket {
  const BookStatusBucket({
    required this.readingStatus,
    required this.books,
  });

  final ReadingStatus readingStatus;
  final List<Book> books;

  BookStatusBucket.forReadingStatus(List<Book> allBooks, this.readingStatus)
    : books = allBooks
      .where((book) => book.readingStatus == readingStatus)
      .toList();
}