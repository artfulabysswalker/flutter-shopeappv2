import 'package:flutter/material.dart';
import '../../db/app_db.dart';
import '../../utils/hash.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  Future<void> _register() async {
    final db = await AppDatabase.instance.database;
    final hashedPassword = hashPassword(_password.text);

    try {
      int id = await db.insert(
        'users',
        {
          'full_name': _fullName.text,
          'username': _username.text,
          'email': _email.text,
          'password': hashedPassword,
        },
  
      );

      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pop(context); // go back to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      debugPrint('Register error: $e'); // print to console for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _fullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _register, child: const Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}
