import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.setData});
  final Function setData;

  @override
  State<LoginPage> createState() => _LoginPageState(setData: setData);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({required this.setData});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Function setData;
  String? token;

  Future<void> login(context) async {
    final response =
        await http.post(Uri.parse('http://192.168.12.1:3000/api/signIn'),
            body: jsonEncode({
              'username': userController.text,
              'password': passwordController.text,
            }),
            headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      setState(() {
        setData(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')));
    }
  }

  Future<void> signup(context) async {
    final response =
        await http.post(Uri.parse('http://192.168.12.1:3000/api/signUp'),
            body: jsonEncode({
              'username': userController.text,
              'password': passwordController.text,
            }),
            headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado correctamente')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Usuario ya existe')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(token ?? ""),
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de usuario',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: const Text('Ingresar'),
            ),
            ElevatedButton(
              onPressed: () {
                signup(context);
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
