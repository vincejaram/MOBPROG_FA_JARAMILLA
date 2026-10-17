import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:intl/intl.dart';

// final formatter = DateFormat.yMd();

class NewBook extends StatefulWidget {
  const NewBook({
    super.key, 
    required this.addOrUpdate,
    this.book,
    this.bookIndex,
  });

  final void Function(Book book) addOrUpdate;
  final Book? book;
  final int? bookIndex;

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pageCountController = TextEditingController();
  double _selectedRating = 0;
  Genre _selectedGenre = genre.firstWhere((genre) => genre.name == 'Fantasy');
  ReadingStatus _selectedReadingStatus = ReadingStatus.toRead;

  void initState(){
    super.initState();
    final book = widget.book;

    if (book != null) {
      _titleController.text = book.title;
      _authorController.text = book.author;
      _pageCountController.text = book.pageCount.toString();
      _selectedRating = book.rating;
      _selectedGenre = book.genre;
      _selectedReadingStatus = book.readingStatus;
    }
  }
  //Category _selectedCategory = Category.food;

  void _submitBookData() {
    int? pageCount = int.tryParse(_pageCountController.text);

    if (_titleController.text.trim().isEmpty
          || _authorController.text.trim().isEmpty
          || pageCount == null) {
      // show error
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text('Invalid Input',
          style: Theme.of(context).textTheme.titleMedium),
        content: Text('Please make sure all fields are properly filled out.',
          style: Theme.of(context).textTheme.titleSmall),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            }, 
            child: Text('Okay')
          ),
        ],
      ));

      return;
    } else if (pageCount <= 0) {
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text('Invalid Input',
          style: Theme.of(context).textTheme.titleMedium),
        content: Text('Page count must be a positive number',
          style: Theme.of(context).textTheme.titleSmall),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            }, 
            child: Text('Okay')
          ),
        ],
      ));

      return;
    }

    Book newBook = Book(
      title: _titleController.text, 
      author: _authorController.text, 
      pageCount: pageCount,
      rating: _selectedReadingStatus == ReadingStatus.finished
        ? _selectedRating
        : 0,
      genre: _selectedGenre,
      readingStatus: _selectedReadingStatus,
    );

    widget.addOrUpdate(newBook);

    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Text('Changes Applied',
          style: Theme.of(context).textTheme.titleMedium),
        content: _selectedReadingStatus == ReadingStatus.finished
          ? Text(
            'Changes have been applied successfully.'
            '\nTitle: ${newBook.title}'
            '\nAuthor: ${newBook.author}'
            '\nPage Count: ${newBook.pageCount}'
            '\nRating: ${newBook.rating}/5'
            '\nGenre: ${_selectedGenre.name}'
            '\nReading Status: ${statusText[_selectedReadingStatus]}',
              style: Theme.of(context).textTheme.titleSmall
          )
          : Text(
            'Changes have been applied successfully.'
            '\nTitle: ${newBook.title}'
            '\nAuthor: ${newBook.author}'
            '\nPage Count: ${newBook.pageCount}'
            '\nRating: ${newBook.rating}/5 (Book Unfinished)'
            '\nGenre: ${_selectedGenre.name}'
            '\nReading Status: ${statusText[_selectedReadingStatus]}',
              style: Theme.of(context).textTheme.titleSmall
          ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            }, 
            child: Text('Okay'),
          ),
        ]
      ));
  }

  void _setRating(double rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pageCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            controller: _titleController,
            maxLength: 60,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              label: Text('Title',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _authorController,
                  maxLength: 30,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: Text('Author',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _pageCountController,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text('Page Count',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Rating', 
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
              RatingBar.builder(
                initialRating: _selectedRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 20,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => const 
                  Icon(
                    Icons.star,
                    color: Colors.amber
                  ), 
                onRatingUpdate: _setRating,
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton<Genre>(
                value: _selectedGenre,
                items: genre
                    .map(
                      (genre) => DropdownMenuItem<Genre>(
                        value: genre,
                        child:
                            Text(genre.name, 
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedGenre = value;
                  });
                },
              ),
              DropdownButton<ReadingStatus>(
                value: _selectedReadingStatus,
                items: ReadingStatus.values
                    .map(
                      (status) => DropdownMenuItem<ReadingStatus>(
                        value: status,
                        child: Text(statusText[status]!, 
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedReadingStatus = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitBookData,
                child: const Text('Save Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}