import 'package:addcs/themes.dart';
import 'package:addcs/view/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    'tampas': 'Tampas',
    'plasticoMisto1': 'Plástico Misto 1L',
    'plasticoMisto5': 'Plástico Misto 5L',
    'plasticoMisto10': 'Plástico Misto 10L',
    'plasticoMisto20': 'Plástico Misto 20L',
    'acoContaminado1': 'Aço Contaminado 1L',
    'acoContaminado5': 'Aço Contaminado 5L',
    'acoContaminado10': 'Aço Contaminado 10L',
    'acoContaminado20': 'Aço Contaminado 20L',
    'papelao': 'Papelão',
    '_aluminio250': 'Alumínio 250ml',
    '_aluminio1': 'Alumínio 1L',
    '_aluminio15': 'Alumínio 1.5L',
    '_aco34': 'Aço 34L',
    'hidroxido': 'Hidróxido',
    'acoNL': 'Aço Não Lavado',
    'ibc': 'IBC',
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
          ),
          body: StreamBuilder<QuerySnapshot>(
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
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      'Relatório $nome - $data - $hora',
                                      style: const TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  ...fieldOrder.map((key) {
                                    if (fields.containsKey(key)) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8),
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
                                ],
                              ),
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
