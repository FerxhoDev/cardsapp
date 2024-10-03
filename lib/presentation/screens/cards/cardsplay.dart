import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slimy_card_plus/slimy_card.dart';

class CategoriaDetallesPage extends StatefulWidget {
  final String categoriaId;

  const CategoriaDetallesPage({super.key, required this.categoriaId});

  @override
  _CategoriaDetallesPageState createState() => _CategoriaDetallesPageState();
}

class _CategoriaDetallesPageState extends State<CategoriaDetallesPage> {
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
  Future<List<Map<String, dynamic>>> _fetchCategoriaCards() async {
    // Accede a la subcolección 'cards' dentro del documento de la categoría seleccionada
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoriaId)
        .collection('cards') // Nombre de la subcolección
        .get();

    // Convierte los documentos en una lista de Mapas, incluyendo el ID del documento
  return querySnapshot.docs.map((doc) {
    // Extrae los datos del documento
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Añade manualmente el ID del documento al mapa de datos
    data['id'] = doc.id;
    return data;
  }).toList();
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
        .collection('categories')
        .doc(widget.categoriaId)
        .get();

    // Asegúrate de que el documento tenga el campo 'nombre'
    final data = docSnapshot.data() as Map<String, dynamic>?;
    return data?['nombre'] ??
        'Sin nombre'; // Devolver un nombre predeterminado si no existe
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
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCategoriaCards(),
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
                            padding: const EdgeInsets.only(
                                top: 5, left: 18, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        // Navegamos pasando tanto categoriaId como cardId en la ruta
                                        context.go('/Home/updateCategoria/${widget.categoriaId}/${card['id']}'); 
                                      },
                                      child: const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.border_color_rounded,
                                            color: Color.fromARGB(
                                                255, 239, 148, 94)),
                                      ),
                                    ),
                                    SizedBox(width: 10),
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
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
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
    );
  }
}
