import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCatmod extends StatefulWidget {
  const AddCatmod({super.key});

  @override
  State<AddCatmod> createState() => _AddCatmodState();
}

class _AddCatmodState extends State<AddCatmod> {
  bool _isCategoryCreated = false;
  String? _categoryId;

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _cardTitleController = TextEditingController();
  final TextEditingController _detalleTitleController = TextEditingController();

  // Método para crear una categoría en Firebase y obtener su ID
  Future<void> _createCategory() async {
    if (_categoryController.text.isEmpty) return;

    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('categories').add({
      'nombre': _categoryController.text,
      'timestamp': FieldValue.serverTimestamp(),
      // Otros campos
    });
    //mostrar mensaje de que se creo la categoria
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('Categoría creada con éxito'),
      ),
    );

    setState(() {
      _isCategoryCreated = true;
      _categoryId = docRef.id; // Almacena el ID de la categoría creada
    });
  }

// Método para agregar una tarjeta a la subcolección de la categoría
  Future<void> _addCardToCategory() async {
    if (_cardTitleController.text.isEmpty ||
        _detalleTitleController.text.isEmpty ||
        _categoryId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(_categoryId)
          .collection('cards')
          .add({
        'titulo': _cardTitleController.text,
        'detalle': _detalleTitleController.text,
        // Otros campos para la tarjeta
      });

      Navigator.pop(context);
      print(
          'Tarjeta agregada con exito'); // Cierra el modal después de agregar la tarjeta
    } catch (e) {
      print('Error al agregar la tarjeta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 600.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 29, 143, 131),
                Color.fromARGB(255, 74, 235, 219)
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 40.h, left: 30.h, right: 30.h),
            child: Column(
              children: [
                //Espacio para validar si la categoría fue creada
                if (!_isCategoryCreated) ...[
                  Text('Agregar Categoria',
                      style: TextStyle(
                          fontSize: 35.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 50.h),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 80.h),
                  ElevatedButton(
                    onPressed: () {
                      _createCategory();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 20.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Agregar',
                        style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ] else ...[
                  Text('Agregar Tarjeta',
                      style: TextStyle(
                          fontSize: 35.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 50.h),
                  TextField(
                    controller: _cardTitleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  TextField(
                    controller: _detalleTitleController,
                    decoration: InputDecoration(
                      labelText: 'Detalle',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 35.h),
                  ElevatedButton(
                    onPressed: () {
                      _addCardToCategory();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 20.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Agregar Tarjeta',
                        style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ]
              ],
            ),
          ),
        ));
  }
}