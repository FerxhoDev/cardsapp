import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //LÑogin con Google
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  //Login con Correo y Contraseña
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future login() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (userCredential.user != null && !userCredential.user!.emailVerified) {
      await userCredential.user!.sendEmailVerification();
      
      // Verifica si el widget sigue montado antes de mostrar el ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, verifica tu correo. Se ha reenviado un correo de verificación.')),
        );
      }
    } else {
      // Redirigir a la pantalla de Home si el correo ya está verificado
      if (mounted) {
        context.go('/Home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión correcto.'),
          ),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay usuario para este correo.'),
          ),
        );
      }
    } else if (e.code == 'wrong-password') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña incorrecta.'),
          ),
        );
      }
    }
  }
}



  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
      if (user != null) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo con el mensaje de bienvenida
          Container(
            height: 600.h,
            decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 50.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'De nuevo!',
                    style: TextStyle(
                      fontSize: 40.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container(
            
          )),

          // Los campos de texto y botones superpuestos sobre el fondo
          Positioned(
            top: 450.h, // Posición relativa del stack
            left: 40.w,  // Margen izquierdo
            right: 40.w, // Margen derecho
            child: Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 253, 251, 251),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    SizedBox(height: 20.h), // Espacio entre campos
                
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
                    
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.teal[200],
                            child: InkWell(
                              onTap: () {
                                login();
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
                      ),

                    SizedBox(height: 40.h), // Espacio antes del botón

                    // Botón para iniciar sesión con Google
                    SignInButton(
                        Buttons.google,
                        text: 'Iniciar con Google',
                        onPressed: () {},
                      ),
                
                    SizedBox(height: 50.h), 
                    
                    GestureDetector(
                      onTap: () {
                        context.goNamed('signIn');
                      },
                      child: const Row(
                        children: [
                          Text('Crearme una cuenta', style: TextStyle(color: Colors.grey),),
                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20, ),
                        ],
                      ),
                    ),// Espacio entre botones
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
