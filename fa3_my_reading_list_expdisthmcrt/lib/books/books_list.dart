import 'package:fa3_my_reading_list_expdisthmcrt/books/book_item.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';
import 'package:flutter/material.dart';

class BooksList extends StatelessWidget {
  const BooksList({
    super.key,
    required this.books,
    required this.removeBook,
    required this.updateBook,
  });

  final List<Book> books;
  final void Function(Book book) removeBook;
  final void Function(int index, Book book) updateBook;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: Theme.of(context).cardTheme.margin,
          ),
          key: ValueKey(books[index]),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd){
              updateBook(index, books[index]);
              return false;
            }
            return true;
          },
          onDismissed: (direction) {
            removeBook(books[index]);
          },
          child: BookItem(books[index]),
        );
      },
    );
  }
}
