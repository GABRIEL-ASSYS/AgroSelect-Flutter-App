import 'package:addcs/themes.dart';
import 'package:addcs/view/relatorios/editar_relatorio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FavoritosRelatoriosScreen extends StatefulWidget {
  const FavoritosRelatoriosScreen({super.key});

  @override
  State<FavoritosRelatoriosScreen> createState() => _FavoritosRelatoriosScreenState();
}

class _FavoritosRelatoriosScreenState extends State<FavoritosRelatoriosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteReport(String documentId) async {
    try {
      await _firestore.collection('embalagens').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Relatório excluído com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir relatório: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportToPDF(DocumentSnapshot doc) async {
    final pdf = pw.Document();

    var fields = doc.data() as Map<String, dynamic>;

    var nome = fields['produtor'] ?? 'Desconhecido';
    var data = fields['data'] ?? '';
    var hora = fields['hora'] ?? '';

    final List<pw.Widget> contentWidgets = [];

    contentWidgets.add(pw.Text('Relatório $nome - $data - $hora',
      style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
    ));

    contentWidgets.add(pw.SizedBox(height: 20));
    contentWidgets.add(pw.Text('Informações do relatório:',
      style: const pw.TextStyle(fontSize: 30),
    ));

    contentWidgets.add(pw.SizedBox(height: 20));

    contentWidgets.addAll(fieldOrder.map((key) {
      if (fields.containsKey(key)) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Text(
            '${fieldLabels[key]}: ${fields[key]}',
            style: const pw.TextStyle(fontSize: 20),
          ),
        );
      } else {
        return pw.SizedBox.shrink();
      }
    }).toList());

    while (contentWidgets.isNotEmpty) {
      final pageContent = contentWidgets.take(30).toList();
      contentWidgets.removeRange(0, pageContent.length);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(16.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: pageContent,
              ),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  final Map<String, String> fieldLabels = {
    'data': 'Data',
    'hora': 'Hora',
    'entregador': 'Entregador',
    'produtor': 'Produtor',
    'telefone': 'Telefone',
    'placa': 'Placa',
    'propriedade': 'Propriedade',
    'cnpj': 'CNPJ',
    'endereco': 'Endereço',
    'pead250': 'PEAD 250ml',
    'pead1': 'PEAD 1L',
    'pead5': 'PEAD 5L',
    'pead10': 'PEAD 10L',
    'pead20': 'PEAD 20L',
    'coex250': 'COEX 250ml',
    'coex1': 'COEX 1L',
    'coex5': 'COEX 5L',
    'coex10': 'COEX 10L',
    'coex20': 'COEX 20L',
    'tampas': 'Tampas Kg',
    'plasticoMisto1': 'Plástico Misto 1L',
    'plasticoMisto5': 'Plástico Misto 5L',
    'plasticoMisto10': 'Plástico Misto 10L',
    'plasticoMisto20': 'Plástico Misto 20L',
    'acoContaminado1': 'Aço Contaminado 1L',
    'acoContaminado5': 'Aço Contaminado 5L',
    'acoContaminado10': 'Aço Contaminado 10L',
    'acoContaminado20': 'Aço Contaminado 20L',
    'papelao': 'Papelão Kg',
    '_aluminio250': 'Alumínio 250ml',
    '_aluminio1': 'Alumínio 1L',
    '_aluminio15': 'Alumínio 1.5L',
    '_aco34': 'Aço 3,4Kg',
    'hidroxido': 'Hidróxido',
    'acoNL': 'Aço Não Lavado',
    'ibc': 'IBC Kg',
    'plasticoQuantidade': 'Quantidade de Plástico',
    'plasticoQuilos': 'Quilos de Plástico',
    'rigida1': 'Rigida 1L',
    'rigida5': 'Rigida 5L',
    'rigida10': 'Rigida 10L',
    'rigida20': 'Rigida 20L',
    'obs': 'Observações',
  };

  final List<String> fieldOrder = [
    'data',
    'hora',
    'entregador',
    'produtor',
    'telefone',
    'placa',
    'propriedade',
    'cnpj',
    'endereco',
    'pead250',
    'pead1',
    'pead5',
    'pead10',
    'pead20',
    'coex250',
    'coex1',
    'coex5',
    'coex10',
    'coex20',
    'tampas',
    'plasticoMisto1',
    'plasticoMisto5',
    'plasticoMisto10',
    'plasticoMisto20',
    'acoContaminado1',
    'acoContaminado5',
    'acoContaminado10',
    'acoContaminado20',
    'papelao',
    '_aluminio250',
    '_aluminio1',
    '_aluminio15',
    '_aco34',
    'hidroxido',
    'acoNL',
    'ibc',
    'plasticoQuantidade',
    'plasticoQuilos',
    'rigida1',
    'rigida5',
    'rigida10',
    'rigida20',
    'obs',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: AppBackground.boxDecoration,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.verde,
            toolbarHeight: 90,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 55,
                  color: AppColors.branco,
                ),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('embalagens')
                .where('favorito', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro ao carregar dados ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum relatório favoritado encontrado.'));
              }

              var data = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: data.map((doc) {
                      var fields = doc.data() as Map<String, dynamic>;

                      var nome = fields['produtor'] ?? 'Desconhecido';
                      var data = fields['data'] ?? '';
                      var hora = fields['hora'] ?? '';

                      return Center(
                        child: SizedBox(
                          width: 600,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Relatório $nome - $data - $hora',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...fieldOrder.map((key) {
                                        if (fields.containsKey(key)) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Text(
                                              '${fieldLabels[key]}: ${fields[key]}',
                                              style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.green,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      }).toList(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditarRelatorioScreen(
                                                      documentId: doc.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 6,
                                                minimumSize: const Size(150, 70),
                                              ),
                                              child: const Text(
                                                'Editar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm = await showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      'Confirmar Exclusão',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Você tem certeza que deseja excluir este relatório?',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 30,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: Colors.green,
                                                          minimumSize: const Size(180, 50),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(context).pop(false),
                                                        child: const Text(
                                                          'Cancelar',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: Colors.green,
                                                          minimumSize: const Size(180, 50),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(context).pop(true),
                                                        child: const Text(
                                                          'Excluir',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ) ??
                                                    false;

                                                if (confirm) {
                                                  await _deleteReport(doc.id);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 6,
                                                minimumSize: const Size(150, 70),
                                              ),
                                              child: const Text(
                                                'Excluir',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await _exportToPDF(doc);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 6,
                                                minimumSize: const Size(150, 70),
                                              ),
                                              child: const Text(
                                                'Exportar PDF',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
