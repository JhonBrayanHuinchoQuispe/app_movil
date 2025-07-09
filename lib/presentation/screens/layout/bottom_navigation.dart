import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({
    super.key, 
    required this.currentIndex
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/inventory');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/ai_alerts');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/reports');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF4757),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_rounded),
          label: 'Inventario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.psychology_rounded),
          label: 'Alertas IA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Reportes',
        ),
      ],
    );
  }
} 