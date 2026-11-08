import 'package:fa4_reverse_engineering/main.dart';
import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:fa4_reverse_engineering/widgets/add_parameter.dart';
import 'package:flutter/material.dart';
import 'package:is_loading_widget/is_loading_widget.dart';

class ParameterScreen extends StatefulWidget {
  const ParameterScreen({super.key});

  @override
  State<ParameterScreen> createState() => _ParameterScreenState();
}

class _ParameterScreenState extends State<ParameterScreen> {
  final _searchController = TextEditingController();
  List<Parameter> searchList = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
      dataLoadFunction(); 
  }

  dataLoadFunction() async {
    setState(() {
      _isLoading = true; 
    });
    searchList = List.from(parameters);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void openAddParameter() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
      builder: (context) => AddParameter(),
      )
    ); 
  }

  void openHomeScreen() {
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            openHomeScreen();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Parameter Settings'),
        actions: [
          IconButton(
            onPressed: () {
              openAddParameter();
            }, 
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: IsLoadingWidget(
        isLoading: _isLoading,
        backGroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  label: Text('Search by Class'),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      searchList = List.from(parameters);
                    } else {
                      searchList.clear();
                      for (Parameter parameter in parameters) {
                        if (parameter.parameterClass.toLowerCase().contains(value.toLowerCase())) {
                          searchList.add(parameter);
                        }
                      }
                    }
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: searchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            height: 24,
                            width: 24,
                            color: searchList[index].color,
                          ),
                          SizedBox(width: 12),
                          Text(searchList[index].parameterName,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal)),
                          Spacer(),
                          Text(searchList[index].parameterClass,
                          style: Theme.of(context).textTheme.titleSmall!),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
