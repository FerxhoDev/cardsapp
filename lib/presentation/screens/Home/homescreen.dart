import 'package:cardsapps/presentation/screens/Home/AddCat.modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _allResults = [];
  List<Map<String, dynamic>> _resultsList = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  _onSearchChanged() {
    searchResultList();
  }

  _onFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  searchResultList() {
    var showResults = <Map<String, dynamic>>[];
    if (_searchController.text.isNotEmpty) {
      showResults = _allResults.where((element) =>
          element['nombre']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())).toList();
    } else {
      showResults = List<Map<String, dynamic>>.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  // Stream para obtener los datos en tiempo real
  Stream<QuerySnapshot> getClientStream() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Ocultar teclado al tocar fuera
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSearchFocused ? 0 : 170.h, // Ajusta la altura cuando el foco está en el campo de búsqueda
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hola,', style: TextStyle(fontSize: 20.sp)),
                            Text('Luis 👋',
                                style: TextStyle(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSearchFocused ? 0 : 100.h, // Ajusta la altura cuando el foco está en el campo de búsqueda
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('¡Explora tu creatividad!',
                            style: TextStyle(
                                fontSize: 40.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          _onSearchChanged();
                        },
                        placeholder: 'Buscar',
                        suffixIcon: const Icon(Icons.cancel_sharp),
                        backgroundColor: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      Text('Categorías',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('Ver todo',
                          style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // StreamBuilder para mostrar categorías en tiempo real
                StreamBuilder<QuerySnapshot>(
                  stream: getClientStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Text('Error al cargar categorías');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No hay categorías disponibles');
                    }

                    // Actualiza la lista _allResults sin usar setState dentro del StreamBuilder
                    _allResults = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      return data;
                    }).toList();

                    // Filtra los resultados fuera del setState
                    _resultsList = _searchController.text.isNotEmpty
                        ? _allResults
                            .where((element) => element['nombre']
                                .toString()
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase()))
                            .toList()
                        : List<Map<String, dynamic>>.from(_allResults);

                    return Container(
                      height: 400.h,
                      padding: const EdgeInsets.only(left: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _resultsList.length,
                        itemBuilder: (context, index) {
                          final categoria = _resultsList[index];
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
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              context.go('/Home/categoria/${categoria['id']}');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(
                                                  255, 239, 148, 94),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text('Ver tarjeta',
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: Colors.white)),
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
                    );
                  },
                ),
                // Espacio extra para que el teclado no cubra el contenido
                SizedBox(height: 60.h),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => const AddCatmod(),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 239, 148, 94),
                          borderRadius: BorderRadius.circular(10),
                          ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Nueva categoría',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            const Icon(Icons.add, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
