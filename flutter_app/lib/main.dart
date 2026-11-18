import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/complaint_service.dart';
import 'screens/add_complaint_screen.dart';
import 'screens/complaint_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const CityCivicApp());
}

class CityCivicApp extends StatelessWidget {
  const CityCivicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..loadSession()),
        ChangeNotifierProvider(create: (_) => ComplaintService()),
      ],
      child: MaterialApp(
        title: 'City Civic App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F8FB),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const RootScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/add-complaint': (context) => const AddComplaintScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == ComplaintDetailScreen.routeName) {
            final id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ComplaintDetailScreen(complaintId: id),
            );
          }
          return null;
        },
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (authService.isCheckingSession) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authService.isLoggedIn) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
