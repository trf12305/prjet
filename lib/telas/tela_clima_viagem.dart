import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TelaClimaViagem extends StatefulWidget {
  const TelaClimaViagem({super.key});

  @override
  State<TelaClimaViagem> createState() => _TelaClimaViagemState();
}

class _TelaClimaViagemState extends State<TelaClimaViagem> {
  final _cidadeController = TextEditingController();
  List<Map<String, dynamic>>? _previsao;
  String? _cidadeAtual;

  Future<void> _buscarClimaPorCidade() async {
    final cidade = _cidadeController.text.trim();
    if (cidade.isEmpty) return;

    final geoUrl =
        'https://geocoding-api.open-meteo.com/v1/search?name=$cidade&count=1';
    final geoResp = await http.get(Uri.parse(geoUrl));
    if (geoResp.statusCode != 200) return;

    final geoData = json.decode(geoResp.body);
    if (geoData['results'] == null || geoData['results'].isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cidade inválida")));
      return;
    }

    final lat = geoData['results'][0]['latitude'];
    final lon = geoData['results'][0]['longitude'];
    final nome = geoData['results'][0]['name'];

    final climaUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=America%2FSao_Paulo';
    final climaResp = await http.get(Uri.parse(climaUrl));
    if (climaResp.statusCode != 200) return;

    final dados = json.decode(climaResp.body);
    final dias = dados['daily']['time'];
    final maxTemp = dados['daily']['temperature_2m_max'];
    final minTemp = dados['daily']['temperature_2m_min'];
    final chuva = dados['daily']['precipitation_sum'];

    setState(() {
      _cidadeAtual = nome;
      _previsao = List.generate(dias.length, (i) {
        return {
          'data': dias[i],
          'max': maxTemp[i],
          'min': minTemp[i],
          'chuva': chuva[i],
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previsão do Tempo"),
        backgroundColor: Colors.green[400],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cidadeController,
              decoration: InputDecoration(
                labelText: "Digite uma cidade",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarClimaPorCidade,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_previsao == null)
              const Text("Pesquise uma cidade para ver a previsão."),
            if (_previsao != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _previsao!.length,
                  itemBuilder: (context, index) {
                    final dia = _previsao![index];
                    final dataFormatada = DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(dia['data']));
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.cloud, color: Colors.blue),
                        title: Text("Dia: $dataFormatada"),
                        subtitle: Text(
                          "🌡️ Máx: ${dia['max']}°C | Mín: ${dia['min']}°C\n☔ Chuva: ${dia['chuva']} mm",
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
