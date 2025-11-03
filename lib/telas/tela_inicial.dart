import 'package:flutter/material.dart';
import 'barra_navegacao.dart';
import 'tela_economias.dart';
import 'tela_gastos.dart';
import 'tela_transporte.dart';
import 'tela_roteiro.dart';
import 'tela_resumo_geral.dart'; 

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _indiceSelecionado = 0;

  final List<Widget> _telas = const [
    TelaEconomias(),
    TelaGastos(),
    TelaTransporte(),
    TelaRoteiro(),
    TelaResumoGeral(), 
  ];

  final List<String> _titulos = const [
    "Economias",
    "Gastos",
    "Transporte",
    "Roteiro",
    "Resumo Geral",
  ];

  void _aoSelecionar(int indice) {
    setState(() {
      _indiceSelecionado = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_indiceSelecionado]),
        backgroundColor: Colors.blueAccent,
      ),
      body: _telas[_indiceSelecionado], 
      bottomNavigationBar: BarraNavegacao(
        indiceSelecionado: _indiceSelecionado,
        aoSelecionar: _aoSelecionar,
      ),
    );
  }
}