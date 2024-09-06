import 'package:addcs/themes.dart';
import 'package:addcs/view/editar_entregador.dart';
import 'package:addcs/view/entregadores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritosEntregadoresScreen extends StatefulWidget {
  const FavoritosEntregadoresScreen({super.key});

  @override
  State<FavoritosEntregadoresScreen> createState() => _FavoritosEntregadoresScreenState();
}

class _FavoritosEntregadoresScreenState extends State<FavoritosEntregadoresScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteEntregador(String documentId) async {
    try {
      await _firestore.collection('entregadores').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entregador excluído com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir entregador: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.verde,
          toolbarHeight: 90,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntregadoresScreen(),
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
          stream: _firestore
              .collection('entregadores')
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
              return const Center(child: Text('Nenhum entregador favorito encontrado'));
            }

            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: data.map((doc) {
                  var fields = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fields['nome'] ?? 'Desconhecido',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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
                              Text(
                                'Produtor: ${fields['produtor'] ?? 'Desconhecido'}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Telefone: ${fields['telefone'] ?? 'Desconhecido'}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Propriedade: ${fields['propriedade'] ?? 'Desconhecido'}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'CNPJ: ${fields['cnpj'] ?? 'Desconhecido'}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Endereço: ${fields['endereco'] ?? 'Desconhecido'}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditarEntregadorScreen(
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
                                            'Você tem certeza que deseja excluir este entregador?',
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
                                              onPressed: () => Navigator.of(context).pop(false),
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
                                              onPressed: () => Navigator.of(context).pop(true),
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
                                      ) ?? false;

                                      if (confirm) {
                                        await _deleteEntregador(doc.id);
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
