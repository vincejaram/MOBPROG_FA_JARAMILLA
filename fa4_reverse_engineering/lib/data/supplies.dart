import 'package:fa4_reverse_engineering/models/supply.dart';

var supplies = [
  Supply(
    name: 'Butterfly Knife', 
    quantity: 3, 
    price: 10.00, 
    parameter: parameters.firstWhere((parameters) => parameters.parameterName == 'Melee'),
  ),
  Supply(
    name: 'Karambit', 
    quantity: 5, 
    price: 8.00, 
    parameter: parameters.firstWhere((parameters) => parameters.parameterName == 'Melee'),
  ),
  Supply(
    name: 'AK-47', 
    quantity: 6, 
    price: 30.00, 
    parameter: parameters.firstWhere((parameters) => parameters.parameterName == 'Assault Rifle'),
  ),
];