import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/screens/chat.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';

  // If this variable is "true", it means user has an account,
  // and wants to log in;
  // and if this variable is "false", it means user doesn't have an account, 
  // and wants to sign up as a new user.
  var _isLogin = true;

  // Submit the User's Email Address and Password
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_isLogin) {
          // User has an account and wants to log in
          final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
        } else {
          // New user (Creating an account for ne user)
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
        }
      } on FirebaseAuthException catch (error) {
        // Handling the error
        if (error.code == 'email_already_in_use') {
          // Some code...
        }

        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message == null ? 'Authentication Failed!' : error.message!,
            ),
          ),
        );
      }
    } else {
      return; // If data is not validate
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // This column will only take as much as space as needed by its content
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            maxLength: 30,
                            decoration: const InputDecoration(
                              label: Text('Email Address'),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@') ||
                                  value.trim().length > 30) {
                                return 'Please enter a valid email address!';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            maxLength: 20,
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ),
                            // Hide character when typed by user
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 6 ||
                                  value.trim().length > 20) {
                                return 'Password must be between 6 and 20 characters length!';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Log in' : 'Sign up'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an account'
                                  : 'I already have an account!',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
