import 'package:addcs/themes.dart';
import 'package:addcs/view/entregador/editar_entregador.dart';
import 'package:addcs/view/entregador/favoritos_entregadores.dart';
import 'package:addcs/view/menu/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EntregadoresScreen extends StatefulWidget {
  const EntregadoresScreen({super.key});

  @override
  State<EntregadoresScreen> createState() => _EntregadoresScreenState();
}

class _EntregadoresScreenState extends State<EntregadoresScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _toggleFavorite(DocumentSnapshot doc) async {
    try {
      bool isFavorito = doc['favorito'] ?? false;
      await _firestore.collection('entregadores').doc(doc.id).update({
        'favorito': !isFavorito,
      });
      setState(() {});
    } catch (e) {
      await showCustomAlertDialog(
        context,
        "Erro ao atualizar favorito: $e",
      );
    }
  }

  Future<void> _deleteEntregador(String documentId) async {
    try {
      await _firestore.collection('entregadores').doc(documentId).delete();
      await showCustomAlertDialog(
        context,
        "Entregador excluído com sucesso.",
      );
    } catch (e) {
      await showCustomAlertDialog(
        context,
        "Erro ao excluir entregador: $e",
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritosEntregadoresScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.star, // Estrela preenchida
                  size: 35,
                  color: AppColors.branco,
                ),
              ),
            ),
          ],
        ),
          body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('entregadores').snapshots(),
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
              return const Center(child: Text('Nenhum entregador encontrado'));
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
                          IconButton(
                            icon: Icon(
                              fields['favorito'] == true ? Icons.star : Icons.star_border,
                              size: 35,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              _toggleFavorite(doc);
                            },
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
}
