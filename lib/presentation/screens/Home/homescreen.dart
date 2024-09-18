import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda para todo el contenido
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola,', style: TextStyle(fontSize: 20.sp)),
                        Text('Luis 👋', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications, color: Colors.grey),
                  ],
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('¡Explora tu creatividad!', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
          
              // Título de Categorías
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  children: [
                    Text('Categorías', style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Ver todo', style: TextStyle(fontSize: 22.sp, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          
              // ListView horizontal con Containers
              Container(
                height: 400.h, // Ajusta la altura según el diseño
                padding: const EdgeInsets.only(left: 20), // Añade un padding para el inicio del ListView
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (index) {
                    return Container(
                      width: 300.w, // Ajusta el ancho según tus necesidades
                      margin: const EdgeInsets.only(right: 16.0), // Espaciado entre los Containers
                      decoration: BoxDecoration(
                        color: Colors.teal[(index % 9 + 1) * 100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                               CircleAvatar(
                                 radius: 20,
                                 backgroundColor: Colors.white,
                                 child: Icon(Icons.favorite_rounded, color: Color.fromARGB(255, 239, 148, 94),),
                               ),
                                SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 200.h,
                              width: 270.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Título de la categoría', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 239, 148, 94),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Ver tarjeta', style: TextStyle(fontSize: 20.sp, color: Colors.white)),
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  }),
                ),
              ),
              SizedBox(height: 60.h),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 148, 94),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('Crear nueva tarjeta', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
