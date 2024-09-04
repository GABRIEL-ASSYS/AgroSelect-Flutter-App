import 'package:addcs/view/entregadores.dart';
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
    var doc = await _firestore.collection('entregadores').doc(widget.documentId).get();
    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;

      fieldOrder.forEach((key) {
        if (data.containsKey(key)) {
          _controllers[key]?.text = data[key] ?? '';
        }
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
            'Editar Entregador',
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
                builder: (context) => const EntregadoresScreen(),
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
}
