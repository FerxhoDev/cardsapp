import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaDetallesPage extends StatelessWidget {
  final String categoriaId;

  const CategoriaDetallesPage({super.key, required this.categoriaId});

  // Método para obtener las tarjetas de la subcolección 'cards'
  Future<List<Map<String, dynamic>>> _fetchCategoriaCards() async {
    // Accede a la subcolección 'cards' dentro del documento de la categoría seleccionada
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriaId)
        .collection('cards') // Nombre de la subcolección
        .get();

    // Convierte los documentos en una lista de Mapas
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Categoría'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCategoriaCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los detalles de la categoría'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron tarjetas para esta categoría'));
          }

          // Lista de tarjetas obtenida de la subcolección 'cards'
          final cards = snapshot.data!;

          // Muestra las tarjetas en una lista
          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['titulo'] ?? 'Sin título',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        card['detalle'] ?? 'Sin detalles',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
