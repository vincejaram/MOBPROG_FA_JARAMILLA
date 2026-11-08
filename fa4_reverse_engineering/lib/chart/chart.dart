import 'package:fa4_reverse_engineering/chart/chart_bar.dart';
import 'package:fa4_reverse_engineering/data/supplies.dart';
import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:fa4_reverse_engineering/models/parameter_name_bucket.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.supplies});

  final List<Supply> supplies;

  List<ParameterNameBucket> get parameterNameBuckets {
    return parameters
      .map((parameters) => ParameterNameBucket.forParameterName(supplies, parameters.parameterName, parameters.color))
      .toList();
  }

  int get maxTotalSupplies {
    int maxTotalSupplies = 0;

    for (final bucket in parameterNameBuckets) {
      if (bucket.supplies.length > maxTotalSupplies) {
        maxTotalSupplies = bucket.supplies.length;
      }
    }

    return maxTotalSupplies;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
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
                ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in parameterNameBuckets)
                  ChartBar(
                    fill: maxTotalSupplies == 0
                        ? 0
                        : bucket.supplies.length / maxTotalSupplies,
                  ),
              ]
            ),
          ),
           SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
          Row(
            children: parameterNameBuckets.map(
              (bucket) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      height: (MediaQuery.sizeOf(context).height)*0.04,
                      width: (MediaQuery.sizeOf(context).width - (parameterNameBuckets.length - 1)*((MediaQuery.sizeOf(context).width)*0.02))/(parameterNameBuckets.length),
                      child: ColoredBox(
                        color: bucket.color,
                      ),
                    )
                  ),
                );
              },
            ).toList(
            ),
          ),
        ],
      ),
    );
  }
}