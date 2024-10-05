import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';


class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _LoginState();
}

class _LoginState extends State<Signin> {
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
                color: const Color.fromARGB(255, 253, 251, 251),
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
                    TextField(
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
                                // signIn();
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
                    
                    Row(
                      children: [
                        const Text('Ya tienes una cuenta?', style: TextStyle(color: Colors.grey),),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () {
                            context.goNamed('login');
                          },
                          child: const Text('Inicia Sesión', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),
                      ],
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
