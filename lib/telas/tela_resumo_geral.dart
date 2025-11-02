import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../db/dados_provider.dart';
import '../db/database_helper.dart';

class TelaResumoGeral extends StatelessWidget {
  const TelaResumoGeral({super.key});

  Future<void> _resetarViagem(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nova Viagem"),
        content: const Text(
          "Tem certeza de que deseja limpar todos os dados da viagem atual? "
              "Essa ação não pode ser desfeita.",
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Confirmar"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    // Apaga tudo do banco
    await BancoDados.instance.limparTudo();

    // Recarrega provider
    await context.read<DadosProvider>().carregarTudo();

    // Mostra aviso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dados zerados! Nova viagem iniciada.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DadosProvider>();
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final totalEconomias =
    provider.economias.fold(0.0, (s, e) => s + (e['valor'] as double));
    final totalGastos =
    provider.gastos.fold(0.0, (s, e) => s + (e['valor'] as double));
    final totalTransportes =
    provider.transportes.fold(0.0, (s, e) => s + (e['custo'] as double));
    final saldo = totalEconomias - (totalGastos + totalTransportes);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumo Geral"),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Nova Viagem",
            onPressed: () => _resetarViagem(context),
          ),
        ],
      ),
      backgroundColor: Colors.green[50],
      body: provider.carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: provider.carregarTudo,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardResumo(totalEconomias, totalGastos, totalTransportes,
                  saldo, formatador),
              const SizedBox(height: 8),
              _construirSecao("Economias", provider.economias, formatador),
              _construirSecao("Gastos", provider.gastos, formatador),
              _construirSecao(
                  "Transportes", provider.transportes, formatador),
              _construirSecao("Roteiros", provider.roteiros, formatador),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _resetarViagem(context),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text("Nova Viagem"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(200, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardResumo(double eco, double gas, double trans, double saldo,
      NumberFormat fmt) {
    return Card(
      color: Colors.green[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Resumo Financeiro",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha("💰 Economias:", fmt.format(eco)),
            _linha("💸 Gastos:", fmt.format(gas)),
            _linha("🚌 Transportes:", fmt.format(trans)),
            const Divider(),
            _linha(
              "💼 Saldo Final:",
              fmt.format(saldo),
              cor: saldo >= 0 ? Colors.green[800] : Colors.red[700],
              negrito: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _linha(String titulo, String valor,
      {Color? cor, bool negrito = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo),
        Text(
          valor,
          style: TextStyle(
            color: cor,
            fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _construirSecao(
      String titulo, List<Map<String, dynamic>> dados, NumberFormat fmt) {
    if (dados.isEmpty) return const SizedBox();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...dados.map((item) {
              final texto = item.containsKey('valor')
                  ? fmt.format(item['valor'])
                  : item.containsKey('custo')
                  ? fmt.format(item['custo'])
                  : item['descricao'] ?? '';
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 4, spreadRadius: 0.5)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                            item['descricao'] ??
                                item['local'] ??
                                item['meio'] ??
                                '',
                            overflow: TextOverflow.ellipsis)),
                    Text(texto),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
