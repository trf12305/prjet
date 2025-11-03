import 'package:flutter/material.dart';
import 'database_helper.dart';

class DadosProvider extends ChangeNotifier {
  List<Map<String, dynamic>> economias = [];
  List<Map<String, dynamic>> gastos = [];
  List<Map<String, dynamic>> transportes = [];
  List<Map<String, dynamic>> roteiros = [];
  bool carregando = false;

  Future<void> carregarTudo() async {
    carregando = true;
    notifyListeners();

    economias = await BancoDados.instance.buscarEconomias();
    gastos = await BancoDados.instance.buscarGastos();
    transportes = await BancoDados.instance.buscarTransportes();
    roteiros = await BancoDados.instance.buscarRoteiros();

    carregando = false;
    notifyListeners();
  }

  Future<void> adicionarRegistro(String tabela, Map<String, dynamic> dados) async {
    switch (tabela) {
      case 'economias':
        await BancoDados.instance.inserirEconomia(dados);
        break;
      case 'gastos':
        await BancoDados.instance.inserirGasto(dados);
        break;
      case 'transportes':
        await BancoDados.instance.inserirTransporte(dados);
        break;
      case 'roteiros':
        await BancoDados.instance.inserirRoteiro(dados);
        break;
    }
    await carregarTudo();
  }
  Future<void> removerRegistro(String tabela, int id) async {
    switch (tabela) {
      case 'economias':
        await BancoDados.instance.deletarEconomia(id);
        break;
      case 'gastos':
        await BancoDados.instance.deletarGasto(id);
        break;
      case 'transportes':
        await BancoDados.instance.deletarTransporte(id);
        break;
      case 'roteiros':
        await BancoDados.instance.deletarRoteiro(id);
        break;
    }
    await carregarTudo();
  }
}