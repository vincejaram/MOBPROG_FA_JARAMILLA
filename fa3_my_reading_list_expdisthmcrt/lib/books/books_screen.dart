import 'package:fa3_my_reading_list_expdisthmcrt/chart/chart.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/books/books_list.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/books/new_book.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/books/new_genre.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/main.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';
import 'package:flutter/material.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final List<Book> listedBooks = [
    Book(
      title: 'Percy Jackson & the Olympians: The Lightning Thief',
      author: 'Rick Riordan',
      pageCount: 377,
      rating: 5,
      genre: genre.firstWhere((genre) => genre.name == 'Fantasy'),
      readingStatus: ReadingStatus.finished,
    ),
    Book(
      title: 'Piranesi',
      author: 'Susanna Clarke',
      pageCount: 272,
      rating: 4,
      genre: genre.firstWhere((genre) => genre.name == 'Mystery'),
      readingStatus: ReadingStatus.finished,
    ),
    Book(
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      pageCount: 496,
      rating: 5,
      genre: genre.firstWhere((genre) => genre.name == 'Science Fiction'),
      readingStatus: ReadingStatus.finished,
    ),
    Book(
      title: 'Red Rising',
      author: 'Pierce Brown',
      pageCount: 377,
      rating: 0,
      genre: genre.firstWhere((genre) => genre.name == 'Science Fiction'),
      readingStatus: ReadingStatus.reading,
    ),
  ];
  
  void _openAddBookModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewBook(addOrUpdate: _addBook),
    );
  }

  void _addBook(Book book) {
    setState(() {
      listedBooks.add(book);
    });
  }

  void _removeBook(Book book) {
    final bookIndex = listedBooks.indexOf(book);

    setState(() {
      listedBooks.remove(book);
    });

    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('Book deleted'),
        duration: Duration(seconds: 3),
        persist: false,
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () {
            setState(() {
              listedBooks.insert(bookIndex, book);
            });
          })
      ),
    );
  }

  void _openUpdateBookModal(int bookIndex, Book book) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewBook(addOrUpdate: (updatedBook) => _updateBook(bookIndex, updatedBook), book: book, bookIndex: bookIndex),
    );
  }

  void _updateBook(int bookIndex, Book book) {
    setState(() {
      listedBooks[bookIndex] = book;
    });
  }

  void _changeThemeMode() {
    themeModeNotifier.value = 
      themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void _openAddGenreModal() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => NewGenre(),
    );
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text('No books found. Start logging some!',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18)),
    );

    if (listedBooks.isNotEmpty) {
      mainContent = BooksList(books: listedBooks, removeBook: _removeBook, updateBook: _openUpdateBookModal);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Books',
        style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: _openAddBookModal,
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: _openAddGenreModal,
            icon: Icon(Icons.menu_book_outlined),
          ),
          IconButton(
            onPressed: _changeThemeMode,
            icon: Icon(
              themeModeNotifier.value == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
              ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Text('The chart!'),
          //Text('The list of expenses!'),
          Chart(books: listedBooks),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
