import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../db/dados_provider.dart';

class TelaTransporte extends StatefulWidget {
  const TelaTransporte({super.key});

  @override
  State<TelaTransporte> createState() => _TelaTransporteState();
}

class _TelaTransporteState extends State<TelaTransporte> {
  String? _transporteSelecionado;
  final _custoController = TextEditingController();
  final _tempoController = TextEditingController();
  final _dataController = TextEditingController();

  final Map<String, Map<String, dynamic>> _transportes = {
    'Avião': {'custo': 700.0, 'tempo': '2h'},
    'Ônibus': {'custo': 1000.0, 'tempo': '5h'},
    'Carro': {'custo': 300.0, 'tempo': '4h'},
    'Trem': {'custo': 200.0, 'tempo': '3h'},
  };

  void _atualizarValores(String transporte) {
    final info = _transportes[transporte]!;
    _custoController.text = (info['custo'] as num).toStringAsFixed(2);
    _tempoController.text = info['tempo'] as String;
  }

  Future<void> _adicionarTransporte() async {
    final transporte = _transporteSelecionado;
    final custo = double.tryParse(_custoController.text.replaceAll(',', '.'));
    final tempo = _tempoController.text.trim();
    final data = _dataController.text.trim();

    final regexData = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (transporte == null || custo == null || tempo.isEmpty || !regexData.hasMatch(data)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    await BancoDados.instance.inserirTransporte({
      'meio': transporte,
      'custo': custo,
      'tempo': tempo,
      'data': data,
    });

    if (mounted) await context.read<DadosProvider>().carregarTudo();

    setState(() {
      _transporteSelecionado = null;
      _custoController.clear();
      _tempoController.clear();
      _dataController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transporte adicionado!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transportes"),
        backgroundColor: Colors.green[400],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _transporteSelecionado,
                items: _transportes.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _transporteSelecionado = val;
                    _atualizarValores(val);
                  });
                },
                decoration: const InputDecoration(labelText: "Meio de Transporte"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _custoController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Custo (R\$)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tempoController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Tempo de viagem"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dataController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: "Data da Viagem (dd/mm/aaaa)",
                  hintText: "Ex: 25/12/2025",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _adicionarTransporte,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  "Adicionar Transporte",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}