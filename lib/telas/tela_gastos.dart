import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/dados_provider.dart';
import '../db/database_helper.dart';

class TelaGastos extends StatefulWidget {
  const TelaGastos({super.key});

  @override
  State<TelaGastos> createState() => _TelaGastosState();
}

class _TelaGastosState extends State<TelaGastos> {
  final _categoriaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  Future<void> _adicionarGasto() async {
    final categoria = _categoriaController.text.trim();
    final descricao = _descricaoController.text.trim();
    final valor = double.tryParse(_valorController.text);

    if (categoria.isEmpty || descricao.isEmpty || valor == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha todos os campos.")));
      return;
    }

    await BancoDados.instance.inserirGasto({
      'categoria': categoria,
      'descricao': descricao,
      'valor': valor,
    });

    if (mounted) await context.read<DadosProvider>().carregarTudo();

    _categoriaController.clear();
    _descricaoController.clear();
    _valorController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Gasto adicionado!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos"), backgroundColor: Colors.green[400]),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _categoriaController,
              decoration: const InputDecoration(labelText: "Categoria"),
            ),
            const SizedBox(height: 10),
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
              onPressed: _adicionarGasto,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
              child: const Text("Adicionar Gasto"),
            ),
          ],
        ),
      ),
    );
  }
}