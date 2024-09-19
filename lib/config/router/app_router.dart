import 'package:cardsapps/presentation/screens/Home/homescreen.dart';
import 'package:cardsapps/presentation/screens/PageView/pageView.dart';
import 'package:cardsapps/presentation/screens/cards/cardsplay.dart';
import 'package:cardsapps/presentation/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter(bool introShown) {
  return GoRouter(
    initialLocation: introShown ? '/Home' : '/pageView',
    routes: <RouteBase>[
      GoRoute(
        path: '/pageView',
        name: 'pageView',
        builder: (BuildContext context, GoRouterState state) => Pageview(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) => const Login(),
      ),
      GoRoute(
        path: '/Home',
        name: 'Home',
        builder: (BuildContext context, GoRouterState state) => const HomePage(),

        routes: <RouteBase>[
          GoRoute(
            path: 'categoria/:id', // Ruta con parámetro `id`
            name: 'categoriaDetalles',
            builder: (BuildContext context, GoRouterState state) {
              // Accedemos a `id` utilizando `pathParameters` en lugar de `params`
              final String categoriaId = state.pathParameters['id']!;
              
              // Pasamos el id como argumento a CategoriaDetallesPage
              return CategoriaDetallesPage(categoriaId: categoriaId);
            },
          ),
        ]
      ),
    ],
  );
}
