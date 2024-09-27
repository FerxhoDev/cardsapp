import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCardmod extends StatelessWidget {
  const AddCardmod({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 8, 122, 111),  Colors.teal],
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 40.h, left: 30.h, right: 30.h),
          child: Column(
            children: [
              Text('Agregar Categoria', style: TextStyle(fontSize: 35.sp, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 50.h),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(height: 80.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Agregar', style: TextStyle(fontSize: 30.sp, color: Colors.teal, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        )
      ),
      )
    );
  }
}