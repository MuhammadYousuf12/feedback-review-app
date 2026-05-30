import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'providers/auth_provider.dart';
import 'providers/feedback_provider.dart';
import 'providers/theme_provider.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/verify_email_screen.dart';
import 'views/admin/admin_dashboard.dart';
import 'views/user/user_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const AuthWrapper(),
      routes: {
        "/user-dashboard": (_) => const UserDashboard(),
        "/admin-dashboard": (_) => const AdminDashboard(),
      },
    );
  }
}

// Routes user based on auth state and role
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // not logged in
    if (user == null) return const LoginScreen();

    // Logged in but email not verified
    if (!user.emailVerified) return const VerifyEmailScreen();

    // Verified - check role & profile status
    return FutureBuilder<String>(
      future: authProvider.getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == "admin"
            ? const AdminDashboard()
            : const UserDashboard();
      },
    );
  }
}
