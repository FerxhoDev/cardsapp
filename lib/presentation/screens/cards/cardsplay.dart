import 'dart:async';
import 'package:cardsapps/presentation/screens/cards/addCArdModal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slimy_card_plus/slimy_card.dart';

class CategoriaDetallesPage extends StatefulWidget {
  final String categoriaId;

  const CategoriaDetallesPage({super.key, required this.categoriaId});

  @override
  _CategoriaDetallesPageState createState() => _CategoriaDetallesPageState();
}

class _CategoriaDetallesPageState extends State<CategoriaDetallesPage> {
  User user = FirebaseAuth.instance.currentUser!; // Usuario actual
  late Timer _timer;
  ValueNotifier<int> _seconds = ValueNotifier<int>(
      0); // Tiempo transcurrido en segundos con ValueNotifier

  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador cuando se entra en la pantalla
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds.value++; // Actualiza el tiempo sin redibujar todo el Widget
    });
  }

  @override
  void dispose() {
    // Cancelar el temporizador cuando se abandona la pantalla
    _timer.cancel();
    _seconds.dispose(); // Liberar el ValueNotifier
    super.dispose();
  }

  // Método para obtener las tarjetas de la subcolección 'cards'
  Stream<List<Map<String, dynamic>>> _categoriaCardsStream() {
    // Accede a la subcolección 'cards' dentro del documento de la categoría seleccionada
    return FirebaseFirestore.instance
        .collection('users') // Colección de usuarios
        .doc(user.uid) // Usa el UID del usuario
        .collection('categories') // Subcolección de categorías del usuario
        .doc(widget.categoriaId) // Documento de la categoría seleccionada
        .collection('cards')
        .orderBy('timestamp', descending: true) // Subcolección de 'cards'
        .snapshots() // Obtiene el stream de cambios en tiempo real
        .map((querySnapshot) {
      // Convierte los documentos en una lista de Mapas, incluyendo el ID del documento
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Añade el ID del documento
        return data;
      }).toList();
    });
  }

  // Método para formatear el tiempo en minutos y segundos
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Método para obtener el nombre de la categoría
  Future<String> _fetchCategoryName() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(widget.categoriaId)
        .get();

    final data = docSnapshot.data() as Map<String, dynamic>?;
    return data?['nombre'] ?? 'Sin nombre'; // Devolver un nombre predeterminado si no existe
  }

  // actualizar nombre de la categoría
  Future<void> _updateCategoryName(String newName) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('categories')
      .doc(widget.categoriaId)
      .update({'nombre': newName});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        // Usar un FutureBuilder para mostrar el nombre de la categoría en el AppBar
        title: FutureBuilder<String>(
          future: _fetchCategoryName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Cargando...'); // Texto mientras carga
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return Text(snapshot.data!); // Muestra el nombre de la categoría
            }
          },
        ),
        actions: [
          IconButton(
  icon: const Icon(Icons.border_color_rounded),
  onPressed: () {
    // Muestra un cuadro de diálogo para actualizar el nombre de la categoría
    showDialog(
      context: context,
      builder: (context) {
        // Controlador para el campo de texto
        TextEditingController _nameController = TextEditingController();

        return AlertDialog(
          title: Text('Editar nombre de la categoría', style: TextStyle(fontSize: 30.sp),),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Ingrese nuevo nombre'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                String newName = _nameController.text;
                if (newName.isNotEmpty) {
                  _updateCategoryName(newName).then((_) {
                    // Actualiza el UI llamando al setState
                    setState(() {});
                    Navigator.of(context).pop(); // Cierra el diálogo
                  });
                }
              },
            ),
          ],
        );
      },
    );
  },
),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _categoriaCardsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar los detalles de la categoría'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No se encontraron tarjetas para esta categoría'));
          }

          // Lista de tarjetas obtenida de la subcolección 'cards'
          final cards = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ValueListenableBuilder<int>(
                        valueListenable: _seconds,
                        builder: (context, value, child) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  size: 30,
                                  color: Color.fromARGB(213, 239, 147, 94),
                                ),
                                Text(
                                  ' ${_formatTime(value)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(213, 239, 147, 94),
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.menu_book_rounded,
                                  color: Color.fromARGB(213, 239, 147, 94),
                                  size: 30,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(20.0),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SlimyCard(
                          topCardWidget: Padding(
                            padding: const EdgeInsets.only(top: 5, left: 18, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),

                                    GestureDetector(
                                      onTap: () {
                                        // Navegamos pasando tanto categoriaId como cardId en la ruta
                                        context.go(
                                            '/Home/updateCategoria/${widget.categoriaId}/${card['id']}');
                                      },
                                      child: const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.border_color_rounded,
                                            color: Color.fromARGB(255, 239, 148, 94)),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Eliminar Tarjeta'),
                                                    content: const Text(
                                                      '¿Estás seguro de eliminar la Tarjeta?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    // Eliminar la tarjeta de la subcolección 'cards'
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('categories')
                                            .doc(widget.categoriaId)
                                            .collection('cards')
                                            .doc(card['id'])
                                            .delete();
                                                  },
                                                  child: const Text('Eliminar'),
                                                ),
                                              ]
                                            );
                                            }
                                          );                                     
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.delete_rounded,
                                            color: Colors.red[400],
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  card['detalle'] ?? 'Sin detalles',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          bottomCardWidget: Text(
                            card['titulo'] ?? 'Sin título',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          color: const Color(0xFFF2F0EB),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => AddCardmod(categoryId: widget.categoriaId),
            isScrollControlled: true
          );
        },
        label: const Text('Añadir Tarjeta'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
