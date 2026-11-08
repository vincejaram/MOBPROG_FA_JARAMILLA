import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:flutter/painting.dart';

class ParameterNameBucket {
  const ParameterNameBucket({
    required this.parameterName,
    required this.supplies,
    required this.color
  });

  final String parameterName;
  final Color color;
  final List<Supply> supplies;

  ParameterNameBucket.forParameterName(List<Supply> allSupplies, this.parameterName, this.color)
    : supplies = allSupplies
      .where((supply) => supply.parameter.parameterName == parameterName)
      .toList();
}