import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookItem extends StatelessWidget {
  final Book book;

  const BookItem(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(book.title,
                  style: Theme.of(context).textTheme.titleMedium),
                ),
                RatingBarIndicator(
                  rating: book.rating,
                  itemCount: 5,
                  itemSize: 16,
                  itemBuilder: (context, index) {
                    return const Icon(
                      Icons.star,
                      color:Colors.amber,
                    );
                  }
                ),
              ],
            ),
            Row(
              children: [
                Text('By ${book.author}',
                style: Theme.of(context).textTheme.titleSmall),
                Spacer(),
                Row(
                  spacing: 5,
                  children: [
                    Icon(book.genre.icon),
                    Text(book.genre.name,
                    style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text('Pages: ${book.pageCount.toString()}',
                style: Theme.of(context).textTheme.titleSmall),
                Spacer(),
                Row(
                  spacing: 5,
                  children: [
                    Text('Status: ${statusText[book.readingStatus]}',
                    style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
