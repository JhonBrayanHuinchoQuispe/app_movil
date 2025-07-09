import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/config/theme.dart';
import '../inventory/inventory_screens.dart';
import '../auth/login_screen.dart';
import '../ai_alerts/ai_alerts_screen.dart';
import '../layout/header.dart';
import 'package:flutter/widgets.dart';
import '../reports/reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final String userName = "Brayan";

  // Datos simulados que normalmente vendrían de tu backend Laravel
  final _dashboardData = {
    'totalSales': 5420.50,
    'dailySales': 850.75,
    'lowStockProducts': 8,
    'expiringProducts': 15,
    'topSellingProducts': [
      {'name': 'Paracetamol', 'sales': 120},
      {'name': 'Ibuprofeno', 'sales': 95},
      {'name': 'Vitamina C', 'sales': 75},
    ],
    'recentAlerts': [
      {
        'type': 'stock',
        'message': 'Paracetamol stock bajo',
        'icon': Icons.warning_rounded,
        'color': Colors.orange,
      },
      {
        'type': 'expiration',
        'message': 'Vitamina C próxima a vencer',
        'icon': Icons.calendar_today,
        'color': Colors.red,
      },
    ]
  };

  final List<Widget> _screens = [
    const HomeContent(),
    const InventoryScreen(),
    const AIAlertsScreen(),  
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _selectedIndex == 1 
          ? null 
          : BarraCompartida(
              titulo: _selectedIndex == 0 ? 'Inicio' : 
                      _selectedIndex == 2 ? 'Alertas IA' : 'Reportes',
              nombreUsuario: userName,
            ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: const Color(0xFFE53E3E),
              unselectedItemColor: const Color(0xFF8B8B8B),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  activeIcon: Icon(Icons.inventory_2),
                  label: 'Inventario',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy_outlined),  
                  activeIcon: Icon(Icons.smart_toy),     
                  label: 'Alertas IA',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined),
                  activeIcon: Icon(Icons.analytics),
                  label: 'Reportes',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  List<String> _getNextFourMonths() {
    final now = DateTime.now();
    final months = <String>[];
    for (var i = 0; i < 4; i++) {
      final month = DateTime(now.year, now.month + i);
      months.add(DateFormat('MMM').format(month).toUpperCase());
    }
    return months;
  }

  @override
  Widget build(BuildContext context) {
    final nextFourMonths = _getNextFourMonths();
    final values = [15, 7, 32, 40]; // Valores de vencimientos
    final int maxValue = ((values.reduce((a, b) => a > b ? a : b) / 10).ceil() * 10) + 10;
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 205,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.7,
                children: [
                  _buildSummaryCard(
                    title: 'Ventas Diarias',
                    value: 'S/ 850.75',
                    icon: Icons.attach_money_rounded,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2196F3).withOpacity(0.7),
                        const Color(0xFF1976D2).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    trend: 'Hoy',
                    isPositiveTrend: true,
                  ),
                  _buildSummaryCard(
                    title: 'Productos Bajos',
                    value: '8',
                    icon: Icons.inventory_2_outlined,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF5252).withOpacity(0.7),
                        const Color(0xFFD32F2F).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    trend: 'Stock',
                    isPositiveTrend: false,
                  ),
                  _buildSummaryCard(
                    title: 'Próx. Vencer',
                    value: '15',
                    icon: Icons.calendar_today,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF9800).withOpacity(0.7),
                        const Color(0xFFF57C00).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    trend: 'Productos',
                    isPositiveTrend: false,
                  ),
                  _buildSummaryCard(
                    title: 'Ventas Total',
                    value: 'S/ 5420.50',
                    icon: Icons.trending_up,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE53E3E).withOpacity(0.7),
                        const Color(0xFFAB2B2B).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    trend: 'Mes',
                    isPositiveTrend: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildChartSection(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Top 3 Productos Más Vendidos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Gráfico de pastel
                    _buildPieChart(),
                    
                    // Ranking de productos
                    _buildProductRankingItem(
                      position: 1,
                      productName: 'Paracetamol',
                      units: 120,
                      revenue: 180.00,
                      color: const Color(0xFFC53030),
                      icon: Icons.looks_one,
                    ),
                    Divider(
                      height: 1, 
                      color: Colors.grey.withOpacity(0.2), 
                      indent: 16, 
                      endIndent: 16
                    ),
                    _buildProductRankingItem(
                      position: 2,
                      productName: 'Ibuprofeno',
                      units: 95,
                      revenue: 142.50,
                      color: const Color(0xFFED4F4F),
                      icon: Icons.looks_two,
                    ),
                    Divider(
                      height: 1, 
                      color: Colors.grey.withOpacity(0.2), 
                      indent: 16, 
                      endIndent: 16
                    ),
                    _buildProductRankingItem(
                      position: 3,
                      productName: 'Vitamina C',
                      units: 75,
                      revenue: 112.50,
                      color: const Color(0xFFFFA5A5),
                      icon: Icons.looks_3,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sección de Alertas Recientes
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Notificaciones Importantes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildNotificationItem(
                    icon: Icons.shopping_cart_outlined,
                    color: Colors.blue[200]!,
                    title: 'Sugerencia de compra',
                    description: 'Revisar lista de productos sugeridos',
                    time: '3h',
                  ),
                  Divider(
                    height: 1, 
                    color: Colors.grey.withOpacity(0.2), 
                    indent: 16, 
                    endIndent: 16
                  ),
                  _buildNotificationItem(
                    icon: Icons.attach_money,
                    color: Colors.green[200]!,
                    title: 'Actualización de precios',
                    description: '8 productos actualizados',
                    time: '4h',
                  ),
                  Divider(
                    height: 1, 
                    color: Colors.grey.withOpacity(0.2), 
                    indent: 16, 
                    endIndent: 16
                  ),
                  _buildNotificationItem(
                    icon: Icons.add_circle_outline,
                    color: Colors.purple[200]!,
                    title: 'Nuevo producto',
                    description: 'Se agregó Paracetamol 500mg',
                    time: '5h',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required LinearGradient gradient,
    required String trend,
    required bool isPositiveTrend,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: Colors.white, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({
    String? title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        child,
      ],
    );
  }

  Widget _buildProductRankingItem({
    required int position,
    required String productName,
    required int units,
    required double revenue,
    required Color color,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          // Ícono de posición
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon != null
                ? Icon(icon, color: color, size: 24)
                : Text(
                    '$position°',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unidades: $units',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Ganancia
          Text(
            'S/ ${revenue.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sectionsSpace: 0,
          sections: [
            PieChartSectionData(
              value: 40,
              color: const Color(0xFFC53030), // Rojo oscuro
              title: 'Paracetamol\n40%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 32,
              color: const Color(0xFFED4F4F), // Rojo medio
              title: 'Ibuprofeno\n32%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 28,
              color: const Color(0xFFFFA5A5), // Rojo claro
              title: 'Vitamina C\n28%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}