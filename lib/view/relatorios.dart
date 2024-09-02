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
                        builder: (context) => const MenuScreen()
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
              stream: _firestore.collection('embalagem').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar dados'),);
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum dado encontrado'));
                }

                var data = snapshot.data!.docs;

                return SingleChildScrollView(
                  child: Column(
                    children: data.map((doc) {
                      var fields = doc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: fields.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${entry.key}: ${entry.value}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            )
          ),
        ),
    );
  }
}
