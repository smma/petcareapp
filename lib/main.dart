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
      home: const AuthGate(),
    );
  }
}

/// Checks for a stored session on startup.
/// - Shows a loading indicator while [AuthProvider.tryAutoLogin] runs.
/// - Navigates to [LoggedInScreen] if a valid session is restored.
/// - Falls back to [LoginScreen] if there is no session or the token refresh fails.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final loggedIn = await auth.tryAutoLogin();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const LoggedInScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Center(
        child: CircularProgressIndicator(color: AppTheme.primaryTeal),
      ),
    );
  }
}
