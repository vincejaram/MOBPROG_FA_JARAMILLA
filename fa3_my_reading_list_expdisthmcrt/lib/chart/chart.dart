import 'package:fa3_my_reading_list_expdisthmcrt/chart/chart_bar.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/main.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/models/book_genre_bucket.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/models/book_status_bucket.dart';
import 'package:flutter/material.dart';
import 'package:fa3_my_reading_list_expdisthmcrt/models/book.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.books});

  final List<Book> books;

  List<BookGenreBucket> get genreBuckets {
    return genre
      .map((genre) => BookGenreBucket.forGenre(books,genre))
      .toList();
  }

  List<BookStatusBucket> get statusBuckets {
    return [
      BookStatusBucket.forReadingStatus(books, ReadingStatus.toRead),
      BookStatusBucket.forReadingStatus(books, ReadingStatus.reading),
      BookStatusBucket.forReadingStatus(books, ReadingStatus.finished),
      BookStatusBucket.forReadingStatus(books, ReadingStatus.didNotFinish),
    ];
  }

  int get maxTotalBooksGenre {
    int maxTotalBooksGenre = 0;

    for (final bucket in genreBuckets) {
      if (bucket.books.length > maxTotalBooksGenre) {
        maxTotalBooksGenre = bucket.books.length;
      }
    }

    return maxTotalBooksGenre;
  }

  int get maxTotalBooksStatus {
    int maxTotalBooksStatus = 0;

    for (final bucket in statusBuckets) {
      if (bucket.books.length > maxTotalBooksStatus) {
        maxTotalBooksStatus = bucket.books.length;
      }
    }

    return maxTotalBooksStatus;
  }

  double _getScoreAverage() {
    double scoreTotal = 0.0;
    int finishedCount = 0;
      for (final bucket in statusBuckets) {
        if (bucket.readingStatus == ReadingStatus.finished) {
          for (final book in bucket.books){
            scoreTotal += book.rating;
            finishedCount++;
          }
        }
      } 
    return finishedCount == 0 
      ? 0 
      : scoreTotal / finishedCount;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: isDarkMode
            ? [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            ]
            : [
              Theme.of(context).colorScheme.primary.withOpacity(0.5),
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ]
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Count of Books per Genre', 
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )
                      ), 
                      const SizedBox(height: 15),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final bucket in genreBuckets)
                              ChartBar(
                                fill: maxTotalBooksGenre == 0
                                  ? 0
                                  : bucket.books.length / maxTotalBooksGenre,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: genreBuckets.map(
                          (bucket) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  bucket.genre.icon,
                                  color: isDarkMode
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.primary,
                                )
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const VerticalDivider(width: 1),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text('Count of Books per Reading Status', 
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant
                        )
                      ), 
                      const SizedBox(height: 15),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final bucket in statusBuckets)
                              ChartBar(
                                fill: maxTotalBooksStatus == 0
                                  ? 0
                                  : bucket.books.length / maxTotalBooksStatus,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: statusBuckets.map(
                          (bucket) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  statusText[bucket.readingStatus]!,
                                  textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              );
                            },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Reading Summary',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final bucket in genreBuckets)
                        Text('${bucket.genre.name}: ${bucket.books.length}',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final bucket in statusBuckets)
                        Text('${statusText[bucket.readingStatus]}: ${bucket.books.length}',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Average Score of Finished Books: ${_getScoreAverage().toStringAsFixed(2)}/5',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}