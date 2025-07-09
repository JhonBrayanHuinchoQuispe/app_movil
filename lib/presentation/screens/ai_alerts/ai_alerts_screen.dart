import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';
import 'package:intl/intl.dart';

class AIAlertsScreen extends StatefulWidget {
  const AIAlertsScreen({super.key});

  @override
  State<AIAlertsScreen> createState() => _AIAlertsScreenState();
}

class _AIAlertsScreenState extends State<AIAlertsScreen> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'all';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _expandedAlertId;

  final List<Map<String, dynamic>> _alerts = [
    {
      'id': '1',
      'title': 'Paracetamol 500mg',
      'subtitle': 'Próximo a vencer',
      'description': 'Vence en 6 días - Stock: 5 unidades',
      'suggestion': 'Aplique descuento del 30% para rotación rápida',
      'urgency': 'high',
      'type': 'expiration',
      'action': 'Promocionar',
      'icon': Icons.warning_rounded,
      'color': const Color(0xFFFF4757),
      'bgColor': const Color(0xFFFFF5F5),
    },
    {
      'id': '2',
      'title': 'Vitamina C 500mg',
      'subtitle': 'Baja rotación',
      'description': 'Sin movimiento por 65 días',
      'suggestion': 'Reubique en estantería principal o promoción cruzada',
      'urgency': 'medium',
      'type': 'rotation',
      'action': 'Reubicar',
      'icon': Icons.trending_down_rounded,
      'color': const Color(0xFFFC8621),
      'bgColor': const Color(0xFFFFF8F0),
    },
    {
      'id': '3',
      'title': 'Antigripales',
      'subtitle': 'Predicción estacional',
      'description': 'Aumento esperado del 45%',
      'suggestion': 'Incremente stock para temporada de invierno',
      'urgency': 'medium',
      'type': 'prediction',
      'action': 'Planificar',
      'icon': Icons.trending_up_rounded,
      'color': const Color(0xFF3498DB),
      'bgColor': const Color(0xFFF0F8FF),
    },
    {
      'id': '4',
      'title': 'Ibuprofeno 400mg',
      'subtitle': 'Stock crítico',
      'description': 'Solo 3 unidades disponibles',
      'suggestion': 'Reabastecer inmediatamente - Demanda alta',
      'urgency': 'high',
      'type': 'stock',
      'action': 'Comprar',
      'icon': Icons.inventory_2_rounded,
      'color': const Color(0xFFE74C3C),
      'bgColor': const Color(0xFFFFF5F5),
    },
    {
      'id': '5',
      'title': 'Aspirina 100mg',
      'subtitle': 'Próximo a vencer',
      'description': 'Vence en 12 días - Stock: 8 unidades',
      'suggestion': 'Considere promoción 2x1 para movimiento rápido',
      'urgency': 'medium',
      'type': 'expiration',
      'action': 'Promocionar',
      'icon': Icons.schedule_rounded,
      'color': const Color(0xFFFF4757),
      'bgColor': const Color(0xFFFFF5F5),
    },
    {
      'id': '6',
      'title': 'Amoxicilina 500mg',
      'subtitle': 'Stock bajo',
      'description': 'Solo 7 unidades disponibles',
      'suggestion': 'Reabastecer pronto - Producto de rotación media',
      'urgency': 'medium',
      'type': 'stock',
      'action': 'Comprar',
      'icon': Icons.inventory_rounded,
      'color': const Color(0xFF3498DB),
      'bgColor': const Color(0xFFF0F8FF),
    },
  ];

  // Simula la fecha de última actualización (en producción, esto vendría de la base de datos o backend)
  final DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Función para obtener el conteo de cada tipo
  int _getFilterCount(String filterType) {
    if (filterType == 'all') return _alerts.length;
    return _alerts.where((alert) => alert['type'] == filterType).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Indicador de última actualización
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 0),
                    child: Text(
                      'Última actualización: ${DateFormat('dd/MM/yyyy').format(_lastUpdate)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildFilterTabs(),
                  _buildAlertsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 90, // Reducido de 120 a 100
      floating: false,
      pinned: false,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE74C3C),
                Color(0xFFFF4757),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), // Reducido padding vertical
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alertas Inteligentes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Basado en análisis de datos',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildRefreshButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    // espaciado para arriba
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.refresh_rounded, color: Colors.white),
        onPressed: _isLoading ? null : _refreshData,
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {
        'label': 'Todos',
        'value': 'all',
        'icon': Icons.all_inclusive,
        'color': const Color(0xFF2196F3), // Azul
      },
      {
        'label': 'Vencimiento',
        'value': 'expiration',
        'icon': Icons.schedule_rounded,
        'color': const Color(0xFFFF4757), // Rojo
      },
      {
        'label': 'Stock',
        'value': 'stock',
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFFD32F2F), // Rojo oscuro para stock crítico
      },
      {
        'label': 'Baja rotación',
        'value': 'rotation',
        'icon': Icons.trending_down_rounded,
        'color': const Color(0xFFFFA000), // Naranja fuerte
      },
      {
        'label': 'Predicción',
        'value': 'prediction',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF00B8D9), // Celeste/azul claro
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 5), // Menos espacio abajo
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter['value'];
            final count = _getFilterCount(filter['value'] as String);
            final color = filter['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () => setState(() => _selectedFilter = filter['value'] as String),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? color : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected ? color : Colors.grey.shade200,
                              width: 2,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ] : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                filter['icon'] as IconData,
                                color: isSelected ? Colors.white : color,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                filter['label'] as String,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Badge contador
                  if (count > 0)
                    Positioned(
                      top: -5,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? color : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: isSelected ? color : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAlertsList() {
    final filteredAlerts = _selectedFilter == 'all'
        ? _alerts
        : _alerts.where((alert) => alert['type'] == _selectedFilter).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: filteredAlerts.map((alert) => _buildAlertCard(alert)).toList(),
      ),
    );
  }

  // Cambiar el diseño de la card de alerta para que el borde izquierdo sea como en inventario
  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final isExpanded = _expandedAlertId == alert['id'];
    Color getBorderColor(Map<String, dynamic> alert) {
      switch (alert['type']) {
        case 'expiration':
          return const Color(0xFFFF4757); // Rojo
        case 'stock':
          if (alert['urgency'] == 'high') {
            return const Color(0xFFD32F2F); // Rojo oscuro para stock crítico
          } else {
            return const Color(0xFFFFA000); // Naranja fuerte para stock bajo
          }
        case 'prediction':
          return const Color(0xFF00B8D9); // Celeste/azul claro
        case 'rotation':
          return const Color(0xFFFFA000); // Naranja fuerte
        default:
          return const Color(0xFF6C63FF);
      }
    }

    final borderColor = getBorderColor(alert);

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedAlertId = isExpanded ? null : alert['id'];
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border(
            left: BorderSide(
              color: borderColor,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila: badge a la izquierda, icono decorativo a la derecha
              Row(
                children: [
                  // Badge del tipo de alerta
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: borderColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: borderColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: borderColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          alert['subtitle'] ?? '',
                          style: TextStyle(
                            color: borderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Icono decorativo a la derecha (más opaco y más cerca del borde)
                  Padding(
                    padding: const EdgeInsets.only(right: 2), // Reduce el espacio al borde
                    child: Icon(
                      alert['icon'] as IconData,
                      size: 30, // Más grande
                      color: borderColor.withOpacity(0.45), // Más opaco y profesional
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Nombre del producto (debajo de la fila)
              Text(
                alert['title'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                alert['description'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        alert['icon'] as IconData,
                        color: borderColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alert['suggestion'] ?? '',
                          style: TextStyle(
                            color: borderColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Explicabilidad de la IA
                if (alert['explanation'] != null && (alert['explanation'] as String).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Color(0xFF1976D2), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alert['explanation'],
                            style: const TextStyle(
                              color: Color(0xFF1976D2),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Botón Ignorar (izquierda)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleDismiss(alert),
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        label: const Text('Ignorar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: BorderSide(color: Colors.grey[400]!),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Botón acción principal (derecha)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleApply(alert),
                        icon: Icon(
                          _getActionIcon(alert['action']),
                          color: Colors.white,
                        ),
                        label: Text(alert['action'] ?? ''),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getActionColor(alert['type'], alert['urgency']),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _handleApply(Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aplicando: ${alert['title']}'),
        backgroundColor: alert['color'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleDismiss(Map<String, dynamic> alert) {
    setState(() {
      _alerts.removeWhere((a) => a['id'] == alert['id']);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alerta ignorada: ${alert['title']}'),
        backgroundColor: Colors.grey[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              // Restaurar la alerta (en producción guardarías el estado)
            });
          },
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    
    // Simular carga de datos
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isLoading = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alertas actualizadas'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }

  IconData _getActionIcon(String? action) {
    switch (action) {
      case 'Promocionar':
        return Icons.campaign_rounded;
      case 'Reubicar':
        return Icons.swap_horiz_rounded;
      case 'Comprar':
        return Icons.shopping_cart_rounded;
      case 'Planificar':
        return Icons.event_note_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  Color _getActionColor(String? type, [String? urgency]) {
    switch (type) {
      case 'expiration':
        return const Color(0xFFFF4757); // Rojo
      case 'rotation':
        return const Color(0xFFFFA000); // Naranja fuerte
      case 'stock':
        if (urgency == 'high') {
          return const Color(0xFFD32F2F); // Rojo oscuro para stock crítico
        } else {
          return const Color(0xFFFFA000); // Naranja fuerte para stock bajo
        }
      case 'prediction':
        return const Color(0xFF00B8D9); // Celeste/azul claro
      default:
        return Colors.blueGrey;
    }
  }
}