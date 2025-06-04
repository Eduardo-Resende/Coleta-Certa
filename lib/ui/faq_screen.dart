// lib/screens/faq_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _buscaController = TextEditingController();

  /// Lista completa de FaqItem carregada do JSON
  List<FaqItem> _todasPerguntas = [];

  /// Lista filtrada (com base no texto de busca)
  List<FaqItem> _perguntasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(_filtrarPerguntas);
    _carregarPerguntasDoJson();
  }

  @override
  void dispose() {
    _buscaController.removeListener(_filtrarPerguntas);
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarPerguntasDoJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/faq/data/faq.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      _todasPerguntas = jsonList
          .map((item) => FaqItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        _perguntasFiltradas = List.from(_todasPerguntas);
      });
    } catch (e) {
      debugPrint('Erro ao carregar JSON de FAQ: $e');
    }
  }

  void _filtrarPerguntas() {
    final texto = _buscaController.text.toLowerCase();
    setState(() {
      if (texto.isEmpty) {
        _perguntasFiltradas = List.from(_todasPerguntas);
      } else {
        _perguntasFiltradas = _todasPerguntas.where((faq) {
          return faq.titulo.toLowerCase().contains(texto);
        }).toList();
      }
    });
  }

  /// Carrega o HTML do asset e abre um Dialog exibindo-o via flutter_html.
  Future<void> _mostrarHtmlDialog(String htmlAssetPath) async {
    String htmlContent;
    try {
      htmlContent = await rootBundle.loadString(htmlAssetPath);
    } catch (e) {
      htmlContent =
          '<html><body><h3>Erro ao carregar conteúdo</h3><p>$e</p></body></html>';
    }

    // Exibe o Dialog com o HTML carregado
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Um botão “X” no canto superior direito (opcional)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // Conteúdo HTML propriamente dito
                Flexible(
                  child: SingleChildScrollView(
                    child: Html(data: htmlContent),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Fechar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            shadowColor: Colors.black,
            elevation: 10,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Perguntas Frequentes',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar pergunta',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // Lista de perguntas
          Expanded(
            child: _perguntasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma pergunta encontrada',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _perguntasFiltradas.length,
                    itemBuilder: (context, index) {
                      final faq = _perguntasFiltradas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            faq.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            _mostrarHtmlDialog(faq.htmlFilePath);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FaqItem {
  final String titulo;
  final String htmlFilePath;

  FaqItem({required this.titulo, required this.htmlFilePath});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      titulo: json['titulo'] as String,
      htmlFilePath: json['htmlFilePath'] as String,
    );
  }
}
