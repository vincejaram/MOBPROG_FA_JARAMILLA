import 'package:fa4_reverse_engineering/data/accounts.dart';
import 'package:fa4_reverse_engineering/main.dart';
import 'package:fa4_reverse_engineering/models/account.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  bool seePassword = true;

  var enteredUsername = '';
  var enteredPassword = '';
  var enteredFirstName = '';
  var enteredLastName = '';

  void _changeThemeMode() {
    themeModeNotifier.value = 
      themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void openLoginScreen() {
    Navigator.of(context).pop();
  }

  void signupAccount() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      bool exists = false;
      for (var account in accounts) {
        if (account.username == enteredUsername) {
          exists = true;
          showDialog(context: context, builder: (ctx) => AlertDialog(
            title: Text('Registration failed.',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14)),
            content: Text('Username already exists.',
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
          return;
        }
      }
      if (exists == false) {
        Account newAccount = Account(
          username: enteredUsername,
          password: enteredPassword,
          firstname: enteredFirstName,
          lastname: enteredLastName,
        );
        setState(() {
          accounts.add(newAccount);
        });
        ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Firefly $enteredUsername added successfully.'),
            duration: Duration(seconds: 3),
            persist: false,
          ),
        );
        openLoginScreen();
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
                  width: (MediaQuery.sizeOf(context).width)*0.15,
                ),
                Text('Become a Firefly',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30)),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('Username' ),
                  ),
                  validator: (value) {
                    if (value == null 
                        || value.isEmpty 
                        || value.trim().length <= 1
                        || value.trim().length > 50) {
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
                  decoration: InputDecoration(
                    label: Text('Password' ),
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
                        || value.trim().length <= 1
                        || value.trim().length > 50) {
                      return 'Kindly enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredPassword = value!;
                  },
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('First Name'),
                  ),
                  validator: (value) {
                    if (value == null 
                        || value.isEmpty 
                        || value.trim().length <= 1
                        || value.trim().length > 50) {
                      return 'Kindly enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredFirstName = value!;
                  },
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('Last Name'),
                  ),
                  validator: (value) {
                    if (value == null 
                        || value.isEmpty 
                        || value.trim().length <= 1
                        || value.trim().length > 50) {
                      return 'Kindly enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredLastName = value!;
                  },
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                SizedBox(
                  height: (MediaQuery.sizeOf(context).height)*0.04,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      signupAccount();
                    },
                    child: Text('Signup'),
                  ),
                ),
                SizedBox(height: (MediaQuery.sizeOf(context).height)*0.015),
                SizedBox(
                  height: (MediaQuery.sizeOf(context).height)*0.04,
                  width: double.infinity,
                  child: TextButton(
                  onPressed: () {
                    openLoginScreen();
                  }, 
                    child: Text('Cancel'),
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
