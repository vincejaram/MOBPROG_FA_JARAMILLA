import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// final formatter = DateFormat.yMd();

class NewGenre extends StatefulWidget {
  const NewGenre({
    super.key, 
  });

  @override
  State<NewGenre> createState() => _NewGenreState();
}

class _NewGenreState extends State<NewGenre> {
  final _genreController = TextEditingController();
  //Category _selectedCategory = Category.food;

  void _submitGenreData() {

    if (_genreController.text.trim().isEmpty) {
      // show error
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text('Invalid Input',
          style: Theme.of(context).textTheme.titleMedium),
        content: Text('Please make sure all fields are filled out.',
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

    genre.add(
      Genre(
        name: _genreController.text,
        icon: Icons.new_label,
      ),
    );

    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Text('New Genre Added', 
          style: Theme.of(context).textTheme.titleMedium),
        content: Text(
          'Genre has been added successfully.',
          style: Theme.of(context).textTheme.titleSmall
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            }, 
            child: Text('Okay'),
          ),
        ]
      ));
  }

  @override
  void dispose() {
    _genreController.dispose();
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
            controller: _genreController,
            maxLength: 40,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              label: Text('New Genre Name',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              )),
            ),
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
                onPressed: _submitGenreData,
                child: const Text('Save Genre'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}