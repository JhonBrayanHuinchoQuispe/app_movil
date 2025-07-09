import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';
import '../auth/login_screen.dart';

// Notificador global para el tema
final ValueNotifier<bool> themeNotifier = ValueNotifier(false);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String adminName = 'Administrador';
  String adminPhoto = 'assets/images/avatar.jpg';
  // Usar el notificador global para el tema
  bool get isDarkMode => themeNotifier.value;

  // Simulación de cambio de foto (en app real usarías ImagePicker)
  void _changePhoto() async {
    // Aquí iría lógica para seleccionar nueva foto
    // Por ahora solo simula un cambio
    setState(() {
      adminPhoto = 'assets/images/avatar.jpg'; // Cambia la ruta si tienes otra imagen
    });
  }

  void _changeName() async {
    final controller = TextEditingController(text: adminName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        adminName = result.trim();
      });
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: AppTheme.primaryRed,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          // Sección Perfil
          Text(
            'Perfil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _changePhoto,
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.primaryRed.withOpacity(0.1),
                    backgroundImage: AssetImage(adminPhoto),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adminName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      OutlinedButton.icon(
                        onPressed: _changeName,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar nombre'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryRed,
                          side: BorderSide(color: AppTheme.primaryRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Sección Preferencias
          Text(
            'Preferencias',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.brightness_6_rounded, color: AppTheme.primaryRed),
              title: const Text('Tema oscuro'),
              trailing: ValueListenableBuilder<bool>(
                valueListenable: themeNotifier,
                builder: (context, value, _) => Switch(
                  value: value,
                  activeColor: AppTheme.primaryRed,
                  onChanged: (val) {
                    themeNotifier.value = val;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Botón cerrar sesión
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Cerrar sesión', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
