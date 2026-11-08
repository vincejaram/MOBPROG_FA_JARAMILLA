import 'package:flutter/material.dart';

final List<Parameter> parameters =  [
  Parameter(parameterName: 'Melee', parameterClass: 'BASE_WEAPON', color: Colors.purple),
  Parameter(parameterName: 'Assault Rifle', parameterClass: 'BASE_WEAPON', color: Colors.lightGreenAccent),
];

class Supply {
  final String name;
  final int quantity;
  final double price;
  final Parameter parameter;

  Supply({
    required this.name,
    required this.quantity,
    required this.price,
    required this.parameter,
  });
}

class Parameter {
  final String parameterName;
  final String parameterClass;
  final Color color;

  Parameter({
    required this.parameterName,
    required this.parameterClass,
    required this.color,
  });
}