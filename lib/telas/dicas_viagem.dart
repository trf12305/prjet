import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DicasViagemSection extends StatelessWidget {
  const DicasViagemSection({super.key});

  Future<List<dynamic>> buscarDicas() async {
    final url = Uri.parse(
        'https://my-json-server.typicode.com/trf12305/dicas_viagem_fake/tips');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      throw Exception('Erro ao buscar dicas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: buscarDicas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar dicas: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Nenhuma dica disponível.');
        }

        final dicas = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💡 Dicas de Viagem',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...dicas.map((dica) => Card(
              color: Colors.orange[50],
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  dica['titulo'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                subtitle: Text(dica['descricao']),
              ),
            )),
          ],
        );
      },
    );
  }
}
