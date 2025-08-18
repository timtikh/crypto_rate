import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref
          .read(authServiceProvider)
          .signIn(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    } catch (e) {
      setState(() {
        _error = "Ошибка входа: ${e.toString()}";
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Вход", style: TextStyle(fontSize: 24)),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (v) =>
                    v != null && v.contains('@') ? null : "Введите email",
                  ),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(labelText: "Пароль"),
                    obscureText: true,
                    validator: (v) =>
                    v != null && v.length >= 6 ? null : "Мин. 6 символов",
                  ),
                  const SizedBox(height: 16),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                      onPressed: _login, child: const Text("Войти")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
