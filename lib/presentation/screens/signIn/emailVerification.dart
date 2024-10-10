import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    // Verificar el estado del email cada 3 segundos.
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    await user?.reload();  // Refresca el estado del usuario en Firebase
    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();  // Detener el temporizador cuando el email esté verificado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo verificado. Redirigiendo...')),
      );
      context.goNamed('Home');  // Redirigir al Home
    }
  }

  @override
  void dispose() {
    timer?.cancel();  // Cancelar el temporizador si el widget se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificación de Correo'),
      ),
      body: Center(
        child: !isEmailVerified
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Revisa tu bandeja de entrada para verificar tu correo.'),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),  // Indicador de progreso mientras espera
                ],
              )
            : const Text('Correo verificado. Redirigiendo...'),
      ),
    );
  }
}
