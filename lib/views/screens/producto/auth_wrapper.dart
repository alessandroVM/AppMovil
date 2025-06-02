import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/views/screens/producto/login_screen.dart';
import 'package:app_movil/views/screens/producto/product_list_screen.dart';
import 'package:app_movil/controllers/auth_controller.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    if (auth.user == null) {
      return LoginScreen(); // remove 'const'
    } else {
      return const ProductListScreen();
    }
  }
}