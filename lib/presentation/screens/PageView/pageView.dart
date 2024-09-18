import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pageview extends StatelessWidget {
  Pageview({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Pagina(color: Colors.white12, pageController: _pageController),
          Pagina2(color: Colors.white24, pageController: _pageController),
          Pagina3(color: Colors.white12, pageController: _pageController),
        ],
      ),
    );
  }
}

class Pagina extends StatelessWidget {
  final Color color;
  final PageController pageController;
  const Pagina({super.key, required this.color, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color,
        child: Column(
          children: [
            Text('Practica con notas', style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold, fontFamily: AutofillHints.postalCode),),
            Container(
              width: double.infinity,
              height: 640.h,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Center(
                    child: Image.asset('images/Hello.png')),
              ),
            ),
            Container(
              width: double.infinity,
              height: 528.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 7, 92, 83), Color.fromARGB(255, 8, 118, 107), Color(0xFF64fcd9)],
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text('Comienza a aprender de inmediato', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                          SizedBox(height: 40.h),
                          Text('Empieza con tarjetas de aprendizaje ya preparadas para tí', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Colors.white),)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 40.sp,),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w,),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Repite el mismo patrón para Pagina2 y Pagina3
class Pagina2 extends StatelessWidget {
  final Color color;
  final PageController pageController;
  const Pagina2({super.key, required this.color, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color,
        child: Column(
          children: [
            Text('Agrega notas', style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold, fontFamily: AutofillHints.postalCode),),
            Container(
              width: double.infinity,
              height: 640.h,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Center(
                    child: Image.asset('images/BusinessPlan.png')),
              ),
            ),
            Container(
              width: double.infinity,
              height: 528.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 7, 92, 83), Color.fromARGB(255, 8, 118, 107), Color(0xFF64fcd9)],
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text('Personaliza tu experiencia', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                          SizedBox(height: 40.h),
                          Text('Empieza a crear tus propias tarjetas con el contenido que te importa', style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Colors.white),)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Container(
                            width: 130.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 40.sp,),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w,),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Pagina3 extends StatelessWidget {
  final Color color;
  final PageController pageController;
  const Pagina3({super.key, required this.color, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color,
        child: Column(
          children: [
            Text('Mantente enfocado', style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold, fontFamily: AutofillHints.postalCode),),
            Container(
              width: double.infinity,
              height: 640.h,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Center(
                    child: Image.asset('images/Done.png')),
              ),
            ),
            Container(
              width: double.infinity,
              height: 528.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 7, 92, 83), Color.fromARGB(255, 8, 118, 107), Color(0xFF64fcd9)],
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text('Alcanza tu objetivo', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                          SizedBox(height: 80.h),
                          Text('¡Mantente enfocado y alcanza tus objetivos con el poder del aprendizaje!', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Colors.white),)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            //Guardar preferencia
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('intro_shown', true);

                            context.go('/Home');
                          },
                          child: Container(
                            width: 200.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Iniciar', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black54),),
                                  Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 40.sp,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w,),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
