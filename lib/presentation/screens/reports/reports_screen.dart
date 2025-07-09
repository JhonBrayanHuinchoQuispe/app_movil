import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../layout/bottom_navigation.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Tipos de reporte
  final List<String> _reportTypes = ['Diario', 'Semanal', 'Mensual', 'Anual'];
  String _selectedReportType = 'Diario';

  // Datos de ejemplo para los gráficos
  final Map<String, List<double>> _salesData = {
    'Diario': [850.75, 920.50, 780.25, 1100.00, 890.60, 1050.75, 1200.50],
    'Semanal': [5420.50, 5890.75, 5210.25, 6100.00, 5780.60],
    'Mensual': [25420.50, 27890.75, 24210.25, 29100.00, 26780.60],
    'Anual': [305420.50, 327890.75, 294210.25, 331100.00, 312780.60]
  };

  DateTimeRange? _selectedDateRange;

  // Método para seleccionar rango de fechas
  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF4757),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Método para exportar a PDF
  Future<void> _exportToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Reporte de Ventas Botica San Antonio', 
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
            ),
          ),
          pw.Paragraph(
            text: 'Reporte generado el ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
          ),
          pw.Table.fromTextArray(
            context: context,
            data: [
              ['Período', 'Ventas'],
              ['Ventas $_selectedReportType', 'S/ ${_salesData[_selectedReportType]!.last.toStringAsFixed(2)}'],
            ],
          ),
        ],
      ),
    );

    // Guardar PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/reporte_ventas.pdf');
    await file.writeAsBytes(await pdf.save());

    // Mostrar diálogo de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF guardado en ${file.path}'),
        backgroundColor: const Color(0xFFFF4757),
      ),
    );
  }

  // Método para exportar a Excel
  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Ventas'];

    // Encabezados
    sheet.appendRow([
      'Período', 
      'Ventas', 
      'Fecha de Exportación'
    ]);

    // Datos
    sheet.appendRow([
      'Ventas $_selectedReportType', 
      _salesData[_selectedReportType]!.last.toStringAsFixed(2), 
      DateFormat('dd/MM/yyyy').format(DateTime.now())
    ]);

    // Guardar Excel
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/reporte_ventas.xlsx');
    await file.writeAsBytes(excel.save()!);

    // Mostrar diálogo de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel guardado en ${file.path}'),
        backgroundColor: const Color(0xFFFF4757),
      ),
    );
  }

  // Método para construir gráfico de ventas
  Widget _buildSalesChart() {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _salesData[_selectedReportType]!
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: const Color(0xFFFF4757),
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFFFF4757).withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF4757),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reportes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                            onPressed: _exportToPDF,
                          ),
                          IconButton(
                            icon: const Icon(Icons.table_chart, color: Colors.white),
                            onPressed: _exportToExcel,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    'Análisis de ventas y stock',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Selector de tipo de reporte
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _reportTypes.map((type) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(type),
                              selected: _selectedReportType == type,
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedReportType = type;
                                  });
                                }
                              },
                              selectedColor: const Color(0xFFFF4757),
                              labelStyle: TextStyle(
                                color: _selectedReportType == type 
                                  ? Colors.white 
                                  : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Selector de rango de fechas
                    Row(
                      children: [
                        const Text(
                          'Rango de Fechas:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: _selectDateRange,
                          child: Text(
                            _selectedDateRange == null
                              ? 'Seleccionar Fechas'
                              : '${DateFormat('dd/MM').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM').format(_selectedDateRange!.end)}',
                            style: const TextStyle(color: Color(0xFFFF4757)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Gráfico de Ventas
                    Expanded(
                      child: _buildSalesChart(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }
} 