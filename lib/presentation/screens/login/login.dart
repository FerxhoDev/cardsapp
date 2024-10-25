import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Login con Google
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  //Login con Correo y Contraseña
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión correcto.'),
        ),
      );
      context.go('/Home');
    }
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No hay usuario para este correo.';
        break;
      case 'wrong-password':
        errorMessage = 'Contraseña incorrecta.';
        break;
      case 'invalid-credential':
        errorMessage = 'Las credenciales proporcionadas son incorrectas o han expirado.';
        break;
      case 'too-many-requests':
        errorMessage = 'Demasiados intentos fallidos. Por favor, intente más tarde.';
        break;
      default:
        errorMessage = 'Error de autenticación: ${e.message}';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 5),
      ),
    );
  } catch (e) {
    if (!mounted) return;
    
    print('Error inesperado: $e'); // Para depuración
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error inesperado. Por favor, intente de nuevo.'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}


//Login con google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // El usuario canceló el inicio de sesión
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Verifica si el usuario ya existe en Firestore
      if (user != null) {
        DocumentReference userRef =
            _firestore.collection('users').doc(user.uid);

        final userSnapshot = await userRef.get();
        if (!userSnapshot.exists) {
          // Si el usuario no existe, crea un nuevo documento
          await userRef.set({
            'name': user.displayName,
            'email': user.email,
          });
        }

        if (mounted) {
          context.go('/Home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Inicio de sesión con Google correcto.')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
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
      body: Column(
        children: [
          // Fondo con el mensaje de bienvenida
          Container(
            height:
                MediaQuery.of(context).size.height * 0.4, // 40% de la pantalla
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
          // Espacio para el contenido: campos de texto y botones
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h), // Espacio superior
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
                    SizedBox(height: 20.h),

                    // Enlace de "Olvidaste tu contraseña"
                    GestureDetector(
                      onTap: () {
                        context.goNamed('forgotpassword');
                      },
                      child: const Text(
                        'Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Botón de Iniciar Sesión
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
                                  'Iniciar Sesión',
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
                    SizedBox(height: 30.h),

                    // Botón de Google
                    SignInButton(
                      Buttons.google,
                      text: 'Iniciar con Google',
                      onPressed: () {
                        signInWithGoogle();
                      },
                    ),
                    SizedBox(height: 30.h), // Espacio inferior

                    // Crear una cuenta
                    GestureDetector(
                      onTap: () {
                        context.goNamed('signIn');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Crearme una cuenta',
                              style: TextStyle(color: Colors.grey)),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
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
