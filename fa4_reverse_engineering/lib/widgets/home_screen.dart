import 'package:fa4_reverse_engineering/main.dart';
import 'package:fa4_reverse_engineering/widgets/parameter_screen.dart';
import 'package:fa4_reverse_engineering/widgets/supply_screen.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.firstname, this.lastname, {super.key});

  final String firstname;
  final String lastname;

  void _changeThemeMode() {
    themeModeNotifier.value = 
      themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {

    void logout() {
      Navigator.of(context).pop();
    }

    void openSupplyScreen() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SupplyScreen(),
        )
      ); 
    }

    void openParameterScreen() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ParameterScreen(),
        )
      ); 
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _changeThemeMode,
          icon: Icon(Icons.brightness_medium),
        ),
        actions: [
          IconButton(
            onPressed: () {
              openParameterScreen();
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (ctx) => AlertDialog(
                title: Text('Logout confirmation',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14)),
                content: Text('Are you sure you want to logout?',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      }, 
                      child: Text('Cancel')
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        logout();
                      }, 
                      child: Text('OK')
                    ),
                    ],
              ));
            }, 
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.sizeOf(context).width)*0.05,
          vertical: (MediaQuery.sizeOf(context).height)*0.05,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text('Hello\n$firstname $lastname\nYou are now one of the Fireflies',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
              Spacer(),
              Image.asset(
                'assets/thelastofus-fireflies-logo.png',
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                width: 300,
              ),
              Spacer(),
              SizedBox(
                height: (MediaQuery.sizeOf(context).height)*0.04,
                child: ElevatedButton(
                  onPressed: () {
                    openSupplyScreen();
                  },
                  child: Text('Check for Supplies'),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}