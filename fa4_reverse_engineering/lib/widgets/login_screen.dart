import 'package:fa4_reverse_engineering/data/accounts.dart';
import 'package:fa4_reverse_engineering/main.dart';
import 'package:fa4_reverse_engineering/widgets/home_screen.dart';
import 'package:fa4_reverse_engineering/widgets/signup_screen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool seePassword = true;

  var enteredUsername = '';
  var enteredPassword = '';
  var loginFirstName = '';
  var loginLastName = '';

  var activeScreen = 'login-screen';

  void switchScreen(String newScreen) {
    setState(() {
      activeScreen = newScreen;
    });
  }

  void _changeThemeMode() {
    themeModeNotifier.value = 
      themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void openSignupScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      )
    );
  }

  void openHomeScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(loginFirstName, loginLastName),
      ),
    );
  }

  void loginAccount() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      
      bool exists = false;
      for (var account in accounts) {
        if (account.username == enteredUsername && account.password == enteredPassword) {
          exists = true;
          loginFirstName = account.firstname;
          loginLastName = account.lastname;
          _usernameController.clear();
          _passwordController.clear();
          openHomeScreen();
          break;
        }
      }
      if (exists == false) {
        showDialog(context: context, builder: (ctx) => AlertDialog(
            title: Text('Login failed.',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14)),
            content: Text('Invalid username or password.',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                }, 
                child: Text('OK')
              ),
            ],
          ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _changeThemeMode,
            icon: Icon(Icons.brightness_medium),
          ),
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
                  Image.asset(
                    'assets/thelastofus-fireflies-logo.png',
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    width: (MediaQuery.sizeOf(context).width)*0.3,
                  ),
                  Spacer(),
                  SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      label: Text('Username'),
                    ),
                    validator: (value) {
                      if (value == null 
                          || value.isEmpty 
                          || value.trim().length <= 1) {
                        return 'Kindly enter your username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      enteredUsername = value!;
                    },
                  ),
                  SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                  TextFormField(
                    obscureText: seePassword,
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      label: Text('Password',),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (seePassword) {
                              seePassword = false;
                            } else {
                              seePassword = true;
                            }
                          });
                        }, 
                        icon: seePassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)
                      ),
                    ),
                    validator: (value) {
                      if (value == null 
                          || value.isEmpty 
                          || value.trim().length <= 1) {
                        return 'Kindly enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      enteredPassword = value!;
                    },
                  ),
                  SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                  SizedBox(
                    height: (MediaQuery.sizeOf(context).height)*0.04,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        loginAccount();
                      },
                      child: Text('Login'),
                    ),
                  ),
                  SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                  SizedBox(
                    height: (MediaQuery.sizeOf(context).height)*0.04,
                    width: double.infinity,
                    child: TextButton(
                    onPressed: () {
                      openSignupScreen();
                    }, 
                      child: Text('Does not have an account yet? Sign Up now!'),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
