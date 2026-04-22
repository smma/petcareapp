// Basic smoke test: ensures the app boots on the Login screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:petcareapp/providers/auth_provider.dart';
import 'package:petcareapp/screens/login_screen.dart';

void main() {
  testWidgets('App opens on the Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Bem-vindo ao PetCare'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });
}
