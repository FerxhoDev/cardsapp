import 'package:cardsapps/presentation/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}

void main() async {
  // Asegúrate de inicializar el binding
  TestWidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp();

  testWidgets('Login with email and password', (WidgetTester tester) async {
    // Crea el mock de FirebaseAuth
    final mockAuth = MockFirebaseAuth();
    final mockUserCredential = MockUserCredential();

    // Simula el inicio de sesión correcto
    when(mockAuth.signInWithEmailAndPassword(
      email: anyNamed('email') as String,
      password: anyNamed('password') as String,
    )).thenAnswer((_) async => mockUserCredential);

    // Cargar la página de login
    await tester.pumpWidget(
      MaterialApp(
        home: Login(),
      ),
    );

    // Encuentra el campo de email y contraseña
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);

    // Introduce datos de prueba
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    // Simula tocar el botón de login
    final loginButton = find.text('Iniciar Sesión');
    await tester.tap(loginButton);

    // Espera a que se procesen los widgets
    await tester.pump();

    // Verifica que el método de inicio de sesión fue llamado con los datos correctos
    verify(mockAuth.signInWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    )).called(1);

    // Verifica que la navegación o el mensaje se muestra correctamente
    expect(find.text('Inicio de sesión correcto.'), findsOneWidget);
  });
}
