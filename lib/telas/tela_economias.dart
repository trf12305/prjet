import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/dados_provider.dart';
import '../db/database_helper.dart';

class TelaEconomias extends StatefulWidget {
  const TelaEconomias({super.key});

  @override
  State<TelaEconomias> createState() => _TelaEconomiasState();
}

class _TelaEconomiasState extends State<TelaEconomias> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  Future<void> _adicionarEconomia() async {
    final descricao = _descricaoController.text;
    final valor = double.tryParse(_valorController.text);
    if (descricao.isEmpty || valor == null) return;

    await BancoDados.instance.inserirEconomia({
      'descricao': descricao,
      'valor': valor,
    });

    if (mounted) {
      await context.read<DadosProvider>().carregarTudo();
    }

    _descricaoController.clear();
    _valorController.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Economia adicionada!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Economias"), backgroundColor: Colors.green[400]),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Valor (R\$)"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _adicionarEconomia,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
              child: const Text("Adicionar Economia"),
            ),
          ],
        ),
      ),
    );
  }
}