import 'package:fa4_reverse_engineering/main.dart';
import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddParameter extends StatefulWidget {
  const AddParameter({super.key});

  @override
  State<AddParameter> createState() => _AddParameterState();
}

class _AddParameterState extends State<AddParameter> {
  final formKey = GlobalKey<FormState>();

  var enteredParameterName = '';
  var enteredParameterClass = '';
  Color pickedColor = Colors.black;

  void openParameterScreen() {
    Navigator.of(context).pop();
  }

  void addNewParameter() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Parameter newParameter = Parameter(
        parameterName: enteredParameterName,
        parameterClass: enteredParameterClass,
        color: pickedColor,
      );
      setState(() {
        parameters.add(newParameter);
      });
      openParameterScreen();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            openParameterScreen();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Add a new parameter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('Parameter Name'),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null 
                        || value.isEmpty 
                        || value.trim().length <= 1
                        || value.trim().length > 50) {
                      return 'Must be between 1 and 50 Characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredParameterName = value!;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 50,
                      decoration: InputDecoration(
                        label: Text('Parameter Class'),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null 
                            || value.isEmpty 
                            || value.trim().length <= 1
                            || value.trim().length > 50) {
                          return 'Must be between 1 and 50 Characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredParameterClass = value!.replaceAll(RegExp(r' '), '_').toUpperCase();
                      },
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        child: ColorPicker(
                          pickerColor: pickedColor, 
                          onColorChanged: (Color color) {
                            setState(() {
                              pickedColor =  color;
                            });
                          },
                          paletteType: PaletteType.hueWheel,
                          labelTypes: const [],
                          enableAlpha: false,
                          hexInputBar: false,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            color: pickedColor,
                          ),
                          Text(pickedColor.toARGB32().toRadixString(16).toUpperCase()),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      formKey.currentState!.reset();
                    },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: addNewParameter,
                    child: Text('Add Parameter'),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
