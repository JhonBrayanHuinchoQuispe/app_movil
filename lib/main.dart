import 'package:flutter/material.dart';
import 'core/config/theme.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/inventory/inventory_screens.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/inventory/scan_product_screen.dart';  
import 'presentation/screens/ai_alerts/ai_alerts_screen.dart';
import 'presentation/screens/reports/reports_screen.dart';

void main() {
  runApp(const BoticaSanAntonioApp());
}

class BoticaSanAntonioApp extends StatelessWidget {
  const BoticaSanAntonioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botica San Antonio',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/scan': (context) => const ScanProductScreen(),
        '/ai_alerts': (context) => const AIAlertsScreen(), 
        '/reports': (context) => const ReportsScreen(),
      },
    );
  }
}