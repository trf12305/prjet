import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../db/dados_provider.dart';
import 'dicas_viagem.dart';

class TelaRoteiro extends StatefulWidget {
  const TelaRoteiro({super.key});

  @override
  State<TelaRoteiro> createState() => _TelaRoteiroState();
}

class _TelaRoteiroState extends State<TelaRoteiro> {
  final _localController = TextEditingController();
  final _dataController = TextEditingController();
  final _descricaoController = TextEditingController();

  Future<void> _adicionarRoteiro() async {
    final local = _localController.text.trim();
    final data = _dataController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (local.isEmpty || data.isEmpty || descricao.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha todos os campos.")));
      return;
    }

    await BancoDados.instance.inserirRoteiro({
      'local': local,
      'data': data,
      'descricao': descricao,
    });

    if (mounted) await context.read<DadosProvider>().carregarTudo();

    _localController.clear();
    _dataController.clear();
    _descricaoController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Roteiro adicionado!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Roteiro"), backgroundColor: Colors.green[400]),
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _localController,
              decoration: const InputDecoration(labelText: "Local"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dataController,
              decoration: const InputDecoration(labelText: "Data (ex: 15/10/2025)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _adicionarRoteiro,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
              child: const Text("Adicionar ao Roteiro"),
            ),
            const SizedBox(height: 20),
            const DicasViagemSection(), // exibe API fake
          ],
        ),
      ),
    );
  }
}