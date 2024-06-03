import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:garbo/screens/profilepage.dart';
import 'package:garbo/services/fire_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusName = FocusNode();
  File? _profileImage;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _nameTextController.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    _focusName.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadProfileImage(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profile_pics')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? profilePicUrl;
        if (_profileImage != null) {
          profilePicUrl = await _uploadProfileImage(_profileImage!);
        }

        User? user = await FireAuth.registerUsingEmailPassword(
          name: _nameTextController.text,
          email: _emailTextController.text,
          password: _passwordTextController.text,
          profilePicUrl: profilePicUrl ?? '',
        );

        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
          );
        }
      } catch (e) {
        print('Failed to register: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/placeholder.png') as ImageProvider,
                  child: Icon(Icons.camera_alt, size: 40),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameTextController,
                focusNode: _focusName,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => Validator.validateName(value),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _emailTextController,
                focusNode: _focusEmail,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => Validator.validateEmail(value),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordTextController,
                focusNode: _focusPassword,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => Validator.validatePassword(value),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
