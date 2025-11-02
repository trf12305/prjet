import 'package:flutter/material.dart';
import 'barra_navegacao.dart';
import 'tela_economias.dart';
import 'tela_gastos.dart';
import 'tela_transporte.dart';
import 'tela_roteiro.dart';
import 'tela_clima_viagem.dart';
import 'tela_resumo_geral.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int indice = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = <Widget>[
      const TelaEconomias(),
      const TelaGastos(),
      const TelaTransporte(),
      const TelaRoteiro(),
      const TelaClimaViagem(),
      TelaResumoGeral(key: UniqueKey()), // força rebuild
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Planejamento de Viagem"),
        backgroundColor: Colors.green[400],
      ),
      body: paginas[indice],
      bottomNavigationBar: BarraNavegacao(
        indiceSelecionado: indice,
        aoSelecionar: (i) => setState(() => indice = i),
      ),
    );
  }
}
