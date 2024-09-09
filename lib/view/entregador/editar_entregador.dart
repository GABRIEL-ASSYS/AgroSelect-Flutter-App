import 'package:addcs/view/entregador/entregadores.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarEntregadorScreen extends StatefulWidget {
  final String documentId;

  const EditarEntregadorScreen({required this.documentId, super.key});

  @override
  _EditarEntregadorScreenState createState() => _EditarEntregadorScreenState();
}

class _EditarEntregadorScreenState extends State<EditarEntregadorScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  final Map<String, String> fieldLabels = {
    'nome': 'Nome',
    'produtor': 'Produtor',
    'telefone': 'Telefone',
    'propriedade': 'Propriedade',
    'cnpj': 'CNPJ',
    'endereco': 'Endereço',
  };

  final List<String> fieldOrder = [
    'nome',
    'produtor',
    'telefone',
    'propriedade',
    'cnpj',
    'endereco',
  ];

  @override
  void initState() {
    super.initState();
    fieldOrder.forEach((key) {
      _controllers[key] = TextEditingController();
    });
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var doc = await _firestore.collection('entregadores').doc(widget.documentId).get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        fieldOrder.forEach((key) {
          _controllers[key]?.text = data[key]?.toString() ?? '';
        });

        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: Documento não encontrado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Image.asset(
          'assets/images/logo.png',
          height: 60,
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            _showExitConfirmationDialog(context);
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
                            controller: _controllers[key],
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
                          await _firestore.collection('entregadores').doc(widget.documentId).update(updatedData);
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

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sair',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: const Text(
            'Nenhuma das alterações feitas será salva, você tem certeza que deseja sair?',
            style: TextStyle(
              fontSize: 30,
              color: Colors.green,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 50),
              ),
              child: const Text(
                'Não',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 50),
              ),
              child: const Text(
                'Sim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const EntregadoresScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
