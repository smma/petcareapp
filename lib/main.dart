import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petcareapp/providers/auth_provider.dart';
import 'package:petcareapp/screens/login_screen.dart';
import 'package:petcareapp/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const PetCareApp(),
    ),
  );
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
