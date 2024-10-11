import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _LoginState();
}

class _LoginState extends State<Signin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Función para registrar un nuevo usuario
  Future<void> _register() async {
    try {
      // Registrar un nuevo usuario
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Actualizar el nombre de usuario
      await userCredential.user!.updateDisplayName(_nameController.text.trim());

      // Guardar el nombre de usuario y correo en Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. Verifica tu correo antes de iniciar sesión.')),
        );
      }

      // Redirigir al usuario a la pantalla de verificación
      context.goNamed('verifyEmail');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrarse: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Fondo con el mensaje de bienvenida
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Center(
                child: Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 50.h),

            // Campos de texto y botón de registro
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Campo de texto para el correo
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Campo de texto para la contraseña
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // Oculta la contraseña
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Botón de registro
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      color: Colors.teal[200],
                      child: InkWell(
                        onTap: () {
                          _register();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20.h,
                            horizontal: 10.w,
                          ),
                          child: Center(
                            child: Text(
                              'Registrarme',
                              style: TextStyle(
                                fontSize: 35.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Redirección para iniciar sesión
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Ya tienes una cuenta?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          context.goNamed('login');
                        },
                        child: const Text(
                          'Inicia Sesión',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
