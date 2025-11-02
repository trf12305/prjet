import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto/telas/tela_principal.dart';
import 'db/dados_provider.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DadosProvider()..carregarTudo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Planejamento de Viagem',
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        // ✅ Localização pt_BR corretamente configurada
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],

        home: const TelaPrincipal(),
      ),
    );
  }
}
