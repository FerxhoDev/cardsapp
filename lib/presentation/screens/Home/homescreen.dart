import 'package:cardsapps/presentation/screens/Home/AddCat.modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  //final User? user = FirebaseAuth.instance.currentUser;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  String? userName;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
    // Escucha los cambios de autenticación
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user; // Actualiza el usuario
        _updateUserName(); // Llama a la función para obtener el nombre
      });
    });
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
      showResults = _allResults
          .where((element) => element['nombre']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    } else {
      showResults = List<Map<String, dynamic>>.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  Future<void> _logout(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay ningún usuario logueado.'),
        ),
      );
      return; // Salir de la función si no hay usuario logueado
    }

    try {
      await FirebaseAuth.instance.signOut(); // Cierra la sesión de Firebase

      // Después de cerrar sesión, redirige al login
      context.go('/Home/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada correctamente.'),
        ),
      );
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
        ),
      );
    }
  }

  // Stream para obtener las categorías del usuario logueado
// Stream para obtener las categorías del usuario autenticado
  Stream<QuerySnapshot> getClientStream() {
    // Obtén el usuario actual
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Si no hay un usuario logueado, devuelve un stream vacío
      return Stream.empty();
    }

    // Accede a Firestore usando el ID del usuario
    return FirebaseFirestore.instance
        .collection('users') // Colección de usuarios
        .doc(currentUser.uid) // Usa el ID del usuario
        .collection('categories') // Subcolección de categorías del usuario
        .orderBy('timestamp', descending: true) // Ordena por timestamp
        .snapshots(); // Escucha los cambios en tiempo real
  }

  // Stream para obtener los datos en tiempo real
  /*Stream<QuerySnapshot> getClientStream() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }*/

// Función para actualizar el nombre de usuario
  Future<void> _updateUserName() async {
    if (user != null) {
      String? name = await getUserName(); // Espera el nombre del usuario
      setState(() {
        userName = name; // Actualiza el estado con el nombre del usuario
      });
    } else {
      setState(() {
        userName = null; // Si no hay usuario, establece el nombre a null
      });
    }
  }

  Future<String?> getUserName() async {
    if (user == null) return null; // Si no hay usuario, retorna null
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      var data = userDoc.data() as Map<String, dynamic>;
      return data.containsKey('name') ? data['name'] : 'Usuario';
    }

    return 'Usuario'; // Si no hay un nombre, usa un valor por defecto
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Iniciar sesión'),
          content: Text('Para agregar nuevas tarjetas debes iniciar sesión.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Acción al confirmar el login
                context.go('/Home/login');
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text('Iniciar sesión'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
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
                  height: _isSearchFocused
                      ? 0
                      : 170
                          .h, // Ajusta la altura cuando el foco está en el campo de búsqueda
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hola,', style: TextStyle(fontSize: 20.sp)),
                            FutureBuilder<String?>(
                              future: getUserName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Cargando...');
                                }
                                return Text(
                                  snapshot.data != null
                                      ? '${snapshot.data} 👋'
                                      : 'Usuario 👋',
                                  style: TextStyle(
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            /*Text(userName != null ? '$userName 👋' : 'Usuario 👋',
                              style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold)
                            ),*/
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            await _logout(
                                context); // Llama a la función de logout de manera correcta
                          },
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSearchFocused
                      ? 0
                      : 100
                          .h, // Ajusta la altura cuando el foco está en el campo de búsqueda
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                                .contains(_searchController.text.toLowerCase()))
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Eliminar categoría'),
                                                    content: const Text(
                                                      '¿Estás seguro de eliminar la categoría?'),
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
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(user!.uid)
                                                        .collection(
                                                            'categories')
                                                        .doc(categoria['id'])
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
                                              color: Colors.red[300]
                                              //Color.fromARGB(255, 239, 148, 94),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              categoria['nombre'] ??
                                                  'Sin título',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              context.go(
                                                  '/Home/categoria/${categoria['id']}');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 239, 148, 94),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                      if (user == null) {
                        _showLoginDialog(context);
                      } else {
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) => const AddCatmod(),
                          isScrollControlled: true,
                        );
                      }
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
