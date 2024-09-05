import 'package:addcs/themes.dart';
import 'package:addcs/view/components/primary_button.dart';
import 'package:addcs/view/entregadores.dart';
import 'package:addcs/view/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CadastroEntregadorScreen extends StatefulWidget {
  const CadastroEntregadorScreen({super.key});

  @override
  State<CadastroEntregadorScreen> createState() => _CadastroEntregadorScreenState();
}

class _CadastroEntregadorScreenState extends State<CadastroEntregadorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _produtorController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _propriedadeController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  final CollectionReference entregadoresCollection = FirebaseFirestore.instance.collection('entregadores');

  Future<void> cadastrarEntregador() async {
    if (_formKey.currentState!.validate()) {
      try {
        await entregadoresCollection.add({
          'nome': _nomeController.text,
          'produtor': _produtorController.text,
          'telefone': _telefoneController.text,
          'propriedade': _propriedadeController.text,
          'cnpj': _cnpjController.text,
          'endereco': _enderecoController.text,
        });
        Fluttertoast.showToast(
          msg: "Cadastro realizado com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 40,
          timeInSecForIosWeb: 3,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuScreen()),
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Erro ao cadastrar: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 25,
          timeInSecForIosWeb: 3,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Por favor, preencha todos os campos corretamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 25,
        timeInSecForIosWeb: 3,
      );
    }
  }

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
                  onPressed: (){
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Cadastro Entregador",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          color: AppColors.verde,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      child: Form(
                        key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _nomeController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "nome do entregador", "Nome"),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um nome';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _produtorController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "nome do produtor", "Produtor"),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um nome';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _telefoneController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "(00)00000-0000", "Telefone"),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um numero de Telefone';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _propriedadeController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "nome da propriedade", "Propriedade"),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um nome';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _cnpjController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "000.000.000-00", "CPF/CNPJ"),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um CPF ou CNPJ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _enderecoController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira o endereço", "Endereço"),
                                  keyboardType: TextInputType.streetAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um endereço';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PrimaryButton(text: 'Cadastrar', onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await entregadoresCollection.add({
                                'nome': _nomeController.text,
                                'produtor': _produtorController.text,
                                'telefone': _telefoneController.text,
                                'propriedade': _propriedadeController.text,
                                'cnpj': _cnpjController.text,
                                'endereco': _enderecoController.text,
                              });
                              Fluttertoast.showToast(
                                msg: "Cadastro realizado com sucesso!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 40,
                                timeInSecForIosWeb: 3,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const EntregadoresScreen()),
                              );
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "Erro ao cadastrar: $e",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 25,
                                timeInSecForIosWeb: 3,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Por favor, preencha todos os campos corretamente.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              fontSize: 25,
                              timeInSecForIosWeb: 3,
                            );
                          }
                        }),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

