import 'package:fa4_reverse_engineering/data/supplies.dart';
import 'package:fa4_reverse_engineering/models/formatter.dart';
import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSupply extends StatefulWidget {
  const AddSupply({super.key});

  @override
  State<AddSupply> createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> {
  final formKey = GlobalKey<FormState>();

  var enteredItemName = '';
  final _quantityController = TextEditingController(text: '1');
  var enteredQuantity = 1;
  var enteredPrice = 1.00;
  var enteredSupplyCategory = parameters.firstWhere((parameters) => parameters.parameterName == 'Melee');

  void openSupplyScreen() { 
    Navigator.of(context).pop();
  }

  void addNewSupply() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Supply newSupply = Supply(
        name: enteredItemName,
        quantity: enteredQuantity,
        price: enteredPrice,
        parameter: enteredSupplyCategory,
      );
      setState(() {
        supplies.add(newSupply);
      });
      openSupplyScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            openSupplyScreen();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Add a new supply'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.sizeOf(context).width)*0.05,
          vertical: (MediaQuery.sizeOf(context).height)*0.05,
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: Text('Item Name' ),
                  ),
                  validator: (value) {
                    if (value == null 
                        || value.isEmpty 
                        || value.trim().length <= 1
                        || value.trim().length > 50) {
                      return 'Input an item name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredItemName = value!;
                  },
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.05),
                TextFormField(
                  controller: _quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumericalRangeFormatter(min: 1, max: 100),
                  ],
                  decoration: InputDecoration(
                    label: Text('Item Quantity'),
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          int quantityInput = int.parse(_quantityController.text);

                          if (quantityInput > 1) {
                            quantityInput--;
                          }

                          _quantityController.text = quantityInput.toString();
                        });
                      }, 
                      icon: Icon(Icons.remove_sharp)
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          int quantityInput = int.parse(_quantityController.text);

                          if (quantityInput < 100) {
                            quantityInput++;
                          }

                          _quantityController.text = quantityInput.toString();
                        });
                      }, 
                      icon: Icon(Icons.add)
                    ),
                  ),
                  onSaved: (value) {
                    enteredQuantity = int.parse(value!);
                  },
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.05),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: '1.00',
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Unit Price'),
                  ),
                  onSaved: (value) {
                    enteredPrice = double.parse(value!);
                  },
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.05),
                Expanded(
                  child: DropdownButtonFormField(
                    initialValue: (parameters.firstWhere((parameters) => parameters.parameterClass == 'BASE_WEAPON')).parameterName,
                      items: [
                        for (final parameter in parameters)
                          DropdownMenuItem(
                            value: parameter.parameterName,
                            child: Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: parameter.color,
                                ),
                                Text(parameter.parameterName),
                              ],
                            ),
                          ),
                      ],
                    onChanged: (value) {
                      setState(() {
                        enteredSupplyCategory = parameters.firstWhere((parameters) => parameters.parameterName == value!);
                      });
                    },
                  ),
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                SizedBox(
                  height: (MediaQuery.sizeOf(context).height)*0.04,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addNewSupply();
                    },
                    child: Text('Save'),
                  ),
                ),
                Spacer(),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
