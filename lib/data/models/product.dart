import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String? description;
  final int stock;
  final int minStock;
  final DateTime expiryDate;
  final double price;
  final double? costPrice;
  final String? barcode;
  final String? category;
  final String? imageUrl;
  final String? batchNumber;
  final String? laboratory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    String? id,
    required this.name,
    required this.brand,
    this.description,
    required this.stock,
    required this.minStock,
    required this.expiryDate,
    required this.price,
    this.costPrice,
    this.barcode,
    this.category,
    this.imageUrl,
    this.batchNumber,
    this.laboratory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();

  // Constructor para crear un nuevo producto desde el escáner
  factory Product.fromScanner({
    required String barcode,
    required String name,
    required double price,
    required int stockEntry,
    required DateTime expiryDate,
    String? batchNumber,
    String? laboratory,
    String? category,
  }) {
    return Product(
      name: name,
      brand: laboratory ?? 'Sin laboratorio',
      stock: stockEntry,
      minStock: 5, // Valor por defecto
      expiryDate: expiryDate,
      price: price,
      barcode: barcode,
      batchNumber: batchNumber,
      laboratory: laboratory,
      category: category,
    );
  }

  // Constructor para crear una entrada de stock
  factory Product.stockEntry({
    required Product existingProduct,
    required int quantity,
    required String batchNumber,
    required DateTime expiryDate,
  }) {
    return existingProduct.copyWith(
      stock: existingProduct.stock + quantity,
      batchNumber: batchNumber,
      expiryDate: expiryDate,
      updatedAt: DateTime.now(),
    );
  }

  Product addStock(int quantity) {
    return copyWith(
      stock: stock + quantity,
      updatedAt: DateTime.now(),
    );
  }

  Product removeStock(int quantity) {
    if (quantity > stock) {
      throw Exception('No hay suficiente stock disponible');
    }
    return copyWith(
      stock: stock - quantity,
      updatedAt: DateTime.now(),
    );
  }

  Product updateInfo({
    String? newName,
    String? newBrand,
    String? newDescription,
    double? newPrice,
    double? newCostPrice,
    String? newCategory,
    int? newMinStock,
    DateTime? newExpiryDate,
    String? newBatchNumber,
    String? newLaboratory,
  }) {
    return copyWith(
      name: newName,
      brand: newBrand,
      description: newDescription,
      price: newPrice,
      costPrice: newCostPrice,
      category: newCategory,
      minStock: newMinStock,
      expiryDate: newExpiryDate,
      batchNumber: newBatchNumber,
      laboratory: newLaboratory,
      updatedAt: DateTime.now(),
    );
  }

  // Getters para estado del producto
  bool get isLowStock => stock <= minStock;
  
  bool get isExpiringSoon {
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  bool get isExpired {
    final now = DateTime.now();
    return expiryDate.isBefore(now);
  }

  bool get isOutOfStock => stock <= 0;

  Color get statusColor {
    if (isExpired) return Colors.red.shade700;
    if (isOutOfStock) return Colors.grey.shade700;
    if (isLowStock) return Colors.orange.shade600;
    if (isExpiringSoon) return Colors.amber.shade600;
    return Colors.green.shade600;
  }

  String get statusText {
    if (isExpired) return 'Vencido';
    if (isOutOfStock) return 'Agotado';
    if (isLowStock) return 'Stock Bajo';
    if (isExpiringSoon) return 'Por Vencer';
    return 'En Stock';
  }

  double get stockProgress {
    if (minStock == 0) return 1.0;
    final maxStock = minStock * 3;
    return (stock / maxStock).clamp(0.0, 1.0);
  }

  Color get stockProgressColor {
    if (isOutOfStock) return Colors.red.shade700;
    if (isLowStock) return Colors.red.shade600;
    if (stock <= minStock * 1.5) return Colors.orange.shade600;
    return Colors.green.shade600;
  }

  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      description: json['description'],
      stock: json['stock'] ?? 0,
      minStock: json['minStock'] ?? 0,
      expiryDate: DateTime.parse(json['expiryDate']),
      price: (json['price'] ?? 0.0).toDouble(),
      costPrice: json['costPrice']?.toDouble(),
      barcode: json['barcode'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      batchNumber: json['batchNumber'],
      laboratory: json['laboratory'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'stock': stock,
      'minStock': minStock,
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'costPrice': costPrice,
      'barcode': barcode,
      'category': category,
      'imageUrl': imageUrl,
      'batchNumber': batchNumber,
      'laboratory': laboratory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? description,
    int? stock,
    int? minStock,
    DateTime? expiryDate,
    double? price,
    double? costPrice,
    String? barcode,
    String? category,
    String? imageUrl,
    String? batchNumber,
    String? laboratory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      expiryDate: expiryDate ?? this.expiryDate,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      batchNumber: batchNumber ?? this.batchNumber,
      laboratory: laboratory ?? this.laboratory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, brand: $brand, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}