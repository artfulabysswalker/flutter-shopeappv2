import 'package:flutter/material.dart';
import '../../db/app_db.dart';
import '../menu/menu_screen.dart';
import '../auth/register_screen.dart'; // import your register screen
import '../../utils/hash.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _u = TextEditingController();
  final _p = TextEditingController();

  Future<void> _login() async {
    final db = await AppDatabase.instance.database;
    final hashedPassword = hashPassword(_p.text);

    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [_u.text, hashedPassword],
    );

    if (res.isNotEmpty && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _u,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _p,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
