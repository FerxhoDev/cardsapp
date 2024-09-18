import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          children: [
            const Text('Login Screen'),
            ElevatedButton(onPressed: (){}, child: const Row(
              children:[
                Text('data'),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ))
          ],
        ),
      ),
    );
  }
}