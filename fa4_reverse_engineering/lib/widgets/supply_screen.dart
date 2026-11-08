import 'package:fa4_reverse_engineering/chart/chart.dart';
import 'package:fa4_reverse_engineering/data/supplies.dart';
import 'package:fa4_reverse_engineering/widgets/add_supply.dart';
import 'package:fa4_reverse_engineering/widgets/supply_list.dart';
import 'package:flutter/material.dart';
import 'package:is_loading_widget/is_loading_widget.dart';

class SupplyScreen extends StatefulWidget {
  const SupplyScreen({super.key});

  @override
  State<SupplyScreen> createState() => _SupplyScreenState();
}

class _SupplyScreenState extends State<SupplyScreen> {
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
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void openAddSupply() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddSupply(),
      )
    ); 
  }

  void openHomeScreen() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text('No supplies found',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18, color: Colors.black)),
    );

    if (supplies.isNotEmpty) {
      mainContent = SupplyList(supplies: supplies);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            openHomeScreen();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Supply Manager'),
        actions: [
          IconButton(
            onPressed: () {
              openAddSupply();
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
            children: [
              Chart(supplies: supplies),
              Expanded(
                child: mainContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
