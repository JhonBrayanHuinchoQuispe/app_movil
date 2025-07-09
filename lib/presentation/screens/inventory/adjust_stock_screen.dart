import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/config/theme.dart';
import '../../../data/models/product.dart';

class AdjustStockScreen extends StatefulWidget {
  final Product product;

  const AdjustStockScreen({
    super.key, 
    required this.product,
  });

  @override
  State<AdjustStockScreen> createState() => _AdjustStockScreenState();
}

class _AdjustStockScreenState extends State<AdjustStockScreen> {
  late TextEditingController _quantityController;
  late TextEditingController _reasonController;
  bool _isAddition = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_quantityController.text.isEmpty) {
      _showError('Ingrese una cantidad');
      return false;
    }

    try {
      final quantity = int.parse(_quantityController.text);
      if (quantity <= 0) {
        _showError('La cantidad debe ser mayor a 0');
        return false;
      }
    } catch (e) {
      _showError('Ingrese una cantidad válida');
      return false;
    }

    if (_reasonController.text.isEmpty) {
      _showError('Ingrese un motivo');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_validateFields()) return;

    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final quantity = int.parse(_quantityController.text);
      final newStock = _isAddition
          ? widget.product.stock + quantity
          : widget.product.stock - quantity;
          
      if (newStock < 0) {
        throw Exception('El stock no puede ser negativo');
      }
      
      final updatedProduct = Product(
        id: widget.product.id,
        name: widget.product.name,
        brand: widget.product.brand,
        stock: newStock,
        minStock: widget.product.minStock,
        expiryDate: widget.product.expiryDate,
        price: widget.product.price,
        costPrice: widget.product.costPrice,
        barcode: widget.product.barcode,
        category: widget.product.category,
        description: widget.product.description,
        createdAt: widget.product.createdAt,
        updatedAt: DateTime.now(),
      );
      
      if (!mounted) return;

      Navigator.pop(context, updatedProduct);
      
      // Modificamos el SnackBar para que aparezca en la parte inferior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _isAddition
                    ? 'Se agregaron $quantity unidades al stock'
                    : 'Se retiraron $quantity unidades del stock',
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            bottom: 20, // Margen inferior
            left: 20,
            right: 20,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAddition ? 'Agregar Stock' : 'Retirar Stock'),
        backgroundColor: AppTheme.primaryRed,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del producto
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.medication_rounded,
                        color: AppTheme.primaryRed,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stock actual: ${widget.product.stock}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tipo de ajuste
              Text(
                'Tipo de Ajuste',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AdjustmentTypeButton(
                      icon: Icons.add_circle_outline,
                      label: 'Entrada',
                      isSelected: _isAddition,
                      onTap: () => setState(() => _isAddition = true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _AdjustmentTypeButton(
                      icon: Icons.remove_circle_outline,
                      label: 'Salida',
                      isSelected: !_isAddition,
                      onTap: () => setState(() => _isAddition = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Cantidad
              Text(
                'Cantidad',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  prefixIcon: Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.grey.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Motivo
              Text(
                'Motivo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ingrese el motivo del ajuste',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryRed,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Guardar Ajuste',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

class _AdjustmentTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdjustmentTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryRed : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primaryRed : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}