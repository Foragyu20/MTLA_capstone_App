import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'textonly.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasToken = await checkToken();

  runApp(MaterialApp(
    home: hasToken
        ?  const Textonly()
        : const LoginPage()
  ));
}

Future<bool> checkToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  return token != null;
}
