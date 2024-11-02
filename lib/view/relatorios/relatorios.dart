import 'dart:convert';
import 'package:addcs/themes.dart';
import 'package:addcs/view/relatorios/editar_relatorio.dart';
import 'package:addcs/view/relatorios/favoritos_relatorios.dart';
import 'package:addcs/view/menu/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

Future<void> _sendEmailWithSendGrid(
    BuildContext context,
    String pdfBase64,
    String recipientEmail,
    String fileName,
    Function(String) showAlertDialogCallback,
    ) async {
  const sendGridApiKey = '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';
  const senderEmail = 'gabrielassysbrachak@gmail.com';
  const senderName = 'ADDCS';

  final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
  final headers = {
    'Authorization': 'Bearer $sendGridApiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'personalizations': [
      {
        'to': [
          {'email': recipientEmail}
        ],
        'subject': 'Relatório PDF',
      }
    ],
    'from': {'email': senderEmail, 'name': senderName},
    'content': [
      {
        'type': 'text/plain',
        'value': 'Segue o relatório PDF em anexo.',
      }
    ],
    'attachments': [
      {
        'content': pdfBase64,
        'type': 'application/pdf',
        'filename': fileName,
        'disposition': 'attachment',
      }
    ]
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 202) {
    print('E-mail enviado com sucesso!');
    showAlertDialogCallback('E-mail enviado com sucesso!');
  } else {
    print('Falha ao enviar e-mail: ${response.body}');
    showAlertDialogCallback('Falha ao enviar e-mail: ${response.body}');
  }
}

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _toggleFavorite(DocumentSnapshot doc) async {
    try {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      bool isFavorito = data?['favorito'] ?? false;

      await _firestore.collection('embalagens').doc(doc.id).update({
        'favorito': !isFavorito,
      });

      setState(() {
      });
    } catch (e) {
      await showCustomAlertDialog(
        context,
        "Não foi possível favoritar o item: $e",
      );
    }
  }

  Future<void> _exportToPDFAndSendEmail(BuildContext context, DocumentSnapshot doc, String recipientEmail) async {
    final pdf = pw.Document();
    var fields = doc.data() as Map<String, dynamic>;

    var nome = fields['produtor'] ?? 'Desconhecido';
    var data = fields['data'] ?? '';
    var hora = fields['hora'] ?? '';

    final List<pw.Widget> contentWidgets = [];
    contentWidgets.add(pw.Text('Relatório $nome - $data - $hora',
      style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
    ));

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

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: contentWidgets,
            ),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    final pdfBase64 = base64Encode(pdfBytes);

    await _sendEmailWithSendGrid(context, pdfBase64, recipientEmail, 'Relatorio_$nome.pdf', (String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('sucesso') ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    });
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
            title: Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(),
                  ),
                );
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.star,
                    color: AppColors.branco,
                    size: 45,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritosRelatoriosScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('embalagens').snapshots(),
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
                  return const Center(child: Text('Nenhum dado encontrado'));
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: IconButton(
                                        icon: Icon(
                                          fields['favorito'] == true ? Icons.star : Icons.star_border,
                                          size: 35,
                                          color: Colors.yellow,
                                        ),
                                        onPressed: () async {
                                          await _toggleFavorite(doc);
                                          setState(() {
                                            fields['favorito'] = !fields['favorito'];
                                          });
                                        },
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
                                                  await _showEmailInputDialog(context, doc);
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
      ),
    );
  }

  Future<void> _deleteReport(String documentId) async {
    try {
      await _firestore.collection('embalagens').doc(documentId).delete();
      await showCustomAlertDialog(
        context,
        "Relatório excluído com sucesso.",
      );
    } catch (e) {
      await showCustomAlertDialog(
        context,
        "Erro ao excluir relatório: $e",
      );
    }
  }

  Future<void> _showEmailInputDialog(BuildContext context, DocumentSnapshot doc) async {
    final emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Enviar PDF por E-mail',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Digite o e-mail',
              hintText: 'exemplo@email.com',
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
              labelStyle: TextStyle(
                fontSize: 30,
                color: Colors.green,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.green,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 50),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final email = emailController.text;
                if (email.isNotEmpty) {
                  await _exportToPDFAndSendEmail(context, doc, email);
                  await showCustomAlertDialog(context, 'PDF enviado para o e-mail com sucesso!');
                } else {
                  await showCustomAlertDialog(context, 'Por favor, insira um e-mail válido.');
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 50),
              ),
              child: const Text(
                'Enviar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> showCustomAlertDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Aviso',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(100, 50),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      );
    },
  );

  await Future.delayed(const Duration(seconds: 2));
}
