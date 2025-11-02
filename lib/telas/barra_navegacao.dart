import 'package:flutter/material.dart';

class BarraNavegacao extends StatelessWidget {
  final int indiceSelecionado;
  final Function(int) aoSelecionar;

  const BarraNavegacao({
    super.key,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceSelecionado,
      onTap: aoSelecionar,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Economias'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Gastos'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Transporte'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Roteiro'),
        BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Clima'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Resumo'),
      ],
    );
  }
}
