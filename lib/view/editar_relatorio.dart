import 'package:addcs/view/relatorios.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarRelatorioScreen extends StatefulWidget {
  final String documentId;

  const EditarRelatorioScreen({required this.documentId, super.key});

  @override
  _EditarRelatorioScreenState createState() => _EditarRelatorioScreenState();
}

class _EditarRelatorioScreenState extends State<EditarRelatorioScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

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
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var doc = await _firestore.collection('embalagens').doc(widget.documentId).get();
    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      fieldOrder.forEach((key) {
        _controllers[key]?.text = data[key] ?? '';
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Editar Relatório',
            style: TextStyle(
              color: Colors.white,
              fontSize: 45,
            ),
          ),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const RelatoriosScreen(),
              ),
            );
          },
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              size: 55,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: fieldOrder.map((key) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: _controllers.putIfAbsent(key, () => TextEditingController()),
                            decoration: InputDecoration(
                              labelText: fieldLabels[key],
                              hintText: fieldLabels[key],
                              hintStyle: const TextStyle(
                                color: Colors.green,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 30,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var updatedData = Map.fromEntries(
                            fieldOrder.map((key) => MapEntry(key, _controllers[key]?.text ?? '')),
                          );
                          await _firestore.collection('embalagens').doc(widget.documentId).update(updatedData);
                          Navigator.pop(context);
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
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
