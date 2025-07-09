import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../../../core/config/theme.dart';
import '../settings/settings_screens.dart';
import '../inventory/inventory_screens.dart';
import '../ai_alerts/ai_alerts_screen.dart';

class NotificationsModal extends StatelessWidget {
  const NotificationsModal({Key? key}) : super(key: key);

  void _navigateBasedOnNotification(BuildContext context, String type, String product) {
    switch (type) {
      case 'vencimiento':
      case 'stock_critico':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InventoryScreen(),
          ),
        );
        break;
      case 'baja_rotacion':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AIAlertsScreen(),
          ),
        );
        break;
      default:
        // Si no hay navegación específica, cerrar el modal
        Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notificaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          _buildOtherNotifications(context),
        ],
      ),
    );
  }

  Widget _buildOtherNotifications(BuildContext context) {
    return Column(
      children: [
        _buildSingleNotification(
          context: context,
          icon: Icons.calendar_today_rounded,
          color: Colors.pink[100]!,
          title: 'Paracetamol',
          subtitle: 'Próximo a vencer en 30 días',
          time: '3h',
          type: 'vencimiento',
        ),
        _buildSingleNotification(
          context: context,
          icon: Icons.trending_down_rounded,
          color: Colors.orange[100]!,
          title: 'Ibuprofeno',
          subtitle: 'Baja rotación en últimos 30 días',
          time: '4h',
          type: 'baja_rotacion',
        ),
        _buildSingleNotification(
          context: context,
          icon: Icons.warning_amber_rounded,
          color: Colors.blue[100]!,
          title: 'Vitamina C',
          subtitle: 'Stock crítico - Reponer inmediatamente',
          time: '5h',
          type: 'stock_critico',
        ),
        _buildSingleNotification(
          context: context,
          icon: Icons.inventory_2_outlined,
          color: Colors.red[100]!,
          title: 'Aspirina',
          subtitle: 'Stock muy bajo - Menos de 10 unidades',
          time: '6h',
          type: 'stock_critico',
        ),
        _buildSingleNotification(
          context: context,
          icon: Icons.local_pharmacy_outlined,
          color: Colors.green[100]!,
          title: 'Amoxicilina',
          subtitle: 'Stock bajo - Menos de 20 unidades',
          time: '7h',
          type: 'stock_critico',
        ),
      ],
    );
  }

  Widget _buildSingleNotification({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
    required String type,
  }) {
    return ListTile(
      onTap: () => _navigateBasedOnNotification(context, type, title),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: color.withOpacity(0.7), size: 24),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: Text(
        time,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class BarraCompartida extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String nombreUsuario;
  
  const BarraCompartida({
    Key? key,
    required this.titulo,
    required this.nombreUsuario,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryRed, AppTheme.darkRed],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const NotificationsModal(),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'configuracion',
                child: Row(
                  children: const [
                    Icon(Icons.settings_outlined, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'cerrar_sesion',
                child: Row(
                  children: const [
                    Icon(Icons.logout_outlined, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'cerrar_sesion') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              } else if (value == 'configuracion') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white24,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    nombreUsuario,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}