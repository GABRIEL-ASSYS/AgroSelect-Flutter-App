import 'package:addcs/themes.dart';
import 'package:addcs/view/components/primary_button.dart';
import 'package:addcs/view/entregador/entregadores.dart';
import 'package:addcs/view/menu/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
var cnpjMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

class CadastroEntregadorScreen extends StatefulWidget {
  const CadastroEntregadorScreen({super.key});

  @override
  State<CadastroEntregadorScreen> createState() => _CadastroEntregadorScreenState();
}

class _CadastroEntregadorScreenState extends State<CadastroEntregadorScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedType = 'CPF';

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _produtorController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _propriedadeController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  final CollectionReference entregadoresCollection = FirebaseFirestore.instance.collection('entregadores');

  bool _isLoading = false;

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##)#####-####',
    filter: { "#": RegExp(r'[0-9]') },
  );

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
        _showSuccessDialog(context);
      } catch (e) {
        await showCustomAlertDialog(
          context,
          "Erro ao cadastrar: $e",
        );
      }
    } else {
      await showCustomAlertDialog(
        context,
        "Por favor, preencha todos os campos corretamente.",
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
              title: Image.asset(
                'assets/images/logo.png',
                height: 60,
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: (){
                    _showExitConfirmationDialog(context);
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
              child: _isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
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
                                  decoration: AppInputs.newInputDecoration("(00)00000-0000", "Telefone"),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [phoneMaskFormatter],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um número de telefone';
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
                                child: Column(
                                  children: [
                                    DropdownButton<String>(
                                      value: _selectedType,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'CPF',
                                          child: Text(
                                            'CPF',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'CNPJ',
                                          child: Text(
                                            'CNPJ',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedType = value;
                                          _cnpjController
                                              .clear();
                                        });
                                      },
                                      underline: Container(
                                        height: 2,
                                        color: Colors.green,
                                      ),
                                      isExpanded: true,
                                      itemHeight: 60,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.green,
                                        size: 40,
                                      ),
                                    ),

                                    TextFormField(
                                      controller: _cnpjController,
                                      style: AppInputs.textDecoration,
                                      decoration:
                                      AppInputs.newInputDecoration(
                                        _selectedType == 'CPF'
                                            ? '000.000.000-00'
                                            : '00.000.000/0000-00',
                                        'CPF/CNPJ',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira um ${_selectedType?.toLowerCase()}';
                                        }
                                        String cleanedValue = value
                                            .replaceAll(RegExp(r'[^\d]'), '');
                                        if (_selectedType == 'CPF' &&
                                            cleanedValue.length != 11) {
                                          return 'O CPF deve ter 11 dígitos';
                                        }
                                        if (_selectedType == 'CNPJ' &&
                                            cleanedValue.length != 14) {
                                          return 'O CNPJ deve ter 14 dígitos';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        _selectedType == 'CPF'
                                            ? cpfMaskFormatter
                                            : cnpjMaskFormatter,
                                      ],
                                    ),
                                  ],
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
                        PrimaryButton(
                          text: 'Cadastrar',
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await entregadoresCollection.add({
                                  'nome': _nomeController.text,
                                  'produtor': _produtorController.text,
                                  'telefone': _telefoneController.text,
                                  'propriedade': _propriedadeController.text,
                                  'cnpj': _cnpjController.text,
                                  'endereco': _enderecoController.text,
                                });

                                await _showSuccessDialog(context);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EntregadoresScreen()),
                                );
                              } catch (e) {
                                await showCustomAlertDialog(
                                  context,
                                  "Erro ao cadastrar: $e",
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });

                              await showCustomAlertDialog(
                                context,
                                "Por favor, preencha todos os campos corretamente.",
                              );
                            }
                          },
                        ),
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
            'Você tem certeza que deseja sair?',
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
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sucesso!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Registro concluído com sucesso!',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EntregadoresScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
            ],
          ),
        );
      },
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

