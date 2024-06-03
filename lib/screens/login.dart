import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garbo/screens/profilepage.dart';
import 'package:garbo/screens/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  get user => null;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailTextController,
                focusNode: _focusEmail,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => _validateEmail(value),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordTextController,
                focusNode: _focusPassword,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => _validatePassword(value),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _signInWithEmailAndPassword();
                  }
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email can\'t be empty';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password can\'t be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      // Handle successful sign in
      print('User signed in: ${userCredential.user!.uid}');

      // Navigate to the profile page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
      );
    } on FirebaseAuthException catch (e) {
      // Handle sign in errors
      print('Failed to sign in: ${e.message}');
    }
  }
}
