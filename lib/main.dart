import 'package:cardsapps/config/router/app_router.dart';
import 'package:cardsapps/config/theme/dark_theme.dart';
import 'package:cardsapps/config/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool introShown = prefs.getBool('intro_shown') ?? false;

  runApp(MyApp(introShown: introShown));
}

class MyApp extends StatelessWidget {
  final bool introShown;
  const MyApp({super.key, required this.introShown});
         
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1280),
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          routerConfig: appRouter(introShown),
          title: 'Cards App',
        );
      },
    );
  }
}