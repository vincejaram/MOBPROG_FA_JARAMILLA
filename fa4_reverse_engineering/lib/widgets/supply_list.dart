import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:fa4_reverse_engineering/widgets/supply_item.dart';
import 'package:flutter/material.dart';

class SupplyList extends StatelessWidget {
  const SupplyList({
    super.key,
    required this.supplies,
  });

  final List<Supply> supplies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: supplies.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.2),
            margin: Theme.of(context).cardTheme.margin,
          ),
          key: ValueKey(supplies[index]),
          onDismissed: (direction) {
          },
          child: SupplyItem(supplies[index]),
        );
      },
    );
  }
}
