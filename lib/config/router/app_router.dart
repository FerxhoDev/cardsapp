import 'package:cardsapps/presentation/screens/Home/homescreen.dart';
import 'package:cardsapps/presentation/screens/PageView/pageView.dart';
import 'package:cardsapps/presentation/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/pageView',
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
    ),
  ]
);
