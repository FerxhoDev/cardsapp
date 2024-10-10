import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardsUpdate extends StatefulWidget {
  final String categoriaId;
  final String cardId;

  const CardsUpdate({super.key, required this.categoriaId, required this.cardId});

  @override
  _CardsUpdateState createState() => _CardsUpdateState();
}

class _CardsUpdateState extends State<CardsUpdate> {
  late TextEditingController _tituloController;
  late TextEditingController _detalleController;

User user = FirebaseAuth.instance.currentUser!; // Usuario actual
  var _counterDetalle = "";

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _detalleController = TextEditingController();
    _fetchCardData(); // Llamada para obtener los datos actuales
  }

  Future<void> _fetchCardData() async {
    try {
      // Acceder al documento de la tarjeta dentro de la subcolección 'cards'
      DocumentSnapshot cardSnapshot = await FirebaseFirestore.instance
          .collection('users') // Colección de usuarios
          .doc(user!.uid) // ID del usuario
          .collection('categories') // Subcolección de categorías
          .doc(widget.categoriaId) // Documento de la categoría
          .collection('cards') // Subcolección 'cards'
          .doc(widget.cardId) // Documento de la tarjeta
          .get();

      // Asegurarse de que los datos existan antes de intentar acceder a ellos
      if (cardSnapshot.exists) {
        Map<String, dynamic> data = cardSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _tituloController.text = data['titulo'] ?? '';
          _detalleController.text = data['detalle'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarjeta no encontrada')),
        );
      }
    } catch (e) {
      print('Error al obtener datos de la tarjeta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar datos de la tarjeta')),
      );
    }
  }

  Future<void> _updateCard() async {
    try {
      // Actualizar los datos de la tarjeta en Firestore
      await FirebaseFirestore.instance
          .collection('users') // Colección de usuarios
          .doc(user!.uid) // ID del usuario
          .collection('categories')
          .doc(widget.categoriaId)
          .collection('cards')
          .doc(widget.cardId)
          .update({
        'titulo': _tituloController.text,
        'detalle': _detalleController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarjeta actualizada con éxito')),
      );
    } catch (e) {
      print('Error al actualizar la tarjeta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la tarjeta')),
      );
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _detalleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: const Text('Actualizar Tarjeta'),
        centerTitle: true,
        backgroundColor: Colors.teal[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold),
                      alignLabelWithHint: false,
                      floatingLabelBehavior: FloatingLabelBehavior.values[2],
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0, bottom: 5.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _counterDetalle = (170 - value.length).toString();
                      });
                    },
                    maxLength: 170,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: _detalleController,
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.teal[800], fontSize: 12, fontWeight: FontWeight.bold),
                      counterText: "$_counterDetalle/170",
                      labelText: 'Detalle',
                      labelStyle: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold),
                      alignLabelWithHint: false,
                      floatingLabelBehavior: FloatingLabelBehavior.values[2],
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                    ),
                    maxLines: 5,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _updateCard,
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
