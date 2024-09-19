import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart'; // Para la navegación

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Método para obtener las categorías desde Firebase
  Future<List<Map<String, dynamic>>> _fetchCategories() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
  return querySnapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id; // Agregar el ID del documento para usarlo en las subcolecciones
    return data;
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar las categorías'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay categorías disponibles'));
              }

              // Lista de categorías obtenida de Firebase
              final categorias = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // ListView horizontal que muestra las categorías de Firebase
                  Container(
                    height: 400.h,
                    padding: const EdgeInsets.only(left: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = categorias[index];
                        return Container(
                          width: 300.w,
                          margin: const EdgeInsets.only(right: 16.0),
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
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: Color.fromARGB(255, 239, 148, 94),
                                      ),
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(categoria['nombre'] ?? 'Sin título',
                                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navegar a la pantalla de detalles de categoría
                                            context.go('/Home/categoria/${categoria['id']}');
                                          },
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
                          ),
                        );
                      },
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
              );
            },
          ),
        ),
      ),
    );
  }
}
