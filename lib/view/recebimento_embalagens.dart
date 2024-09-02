
import 'package:addcs/themes.dart';
import 'package:addcs/view/components/primary_button.dart';
import 'package:addcs/view/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecebimentoEmbalagensScreen extends StatefulWidget {
  const RecebimentoEmbalagensScreen({super.key});

  @override
  State<RecebimentoEmbalagensScreen> createState() => _RecebimentoEmbalagensScreenState();
}

class _RecebimentoEmbalagensScreenState extends State<RecebimentoEmbalagensScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _entregadorController = TextEditingController();
  final TextEditingController _produtorController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _propriedadeController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _pead250Controller = TextEditingController();
  final TextEditingController _pead1Controller = TextEditingController();
  final TextEditingController _pead5Controller = TextEditingController();
  final TextEditingController _pead10Controller = TextEditingController();
  final TextEditingController _pead20Controller = TextEditingController();
  final TextEditingController _coex250Controller = TextEditingController();
  final TextEditingController _coex1Controller = TextEditingController();
  final TextEditingController _coex5Controller = TextEditingController();
  final TextEditingController _coex10Controller = TextEditingController();
  final TextEditingController _coex20Controller = TextEditingController();
  final TextEditingController _tampasController = TextEditingController();
  final TextEditingController _plasticoMisto1Controller = TextEditingController();
  final TextEditingController _plasticoMisto5Controller = TextEditingController();
  final TextEditingController _plasticoMisto10Controller = TextEditingController();
  final TextEditingController _plasticoMisto20Controller = TextEditingController();
  final TextEditingController _acoContaminado1Controller = TextEditingController();
  final TextEditingController _acoContaminado5Controller = TextEditingController();
  final TextEditingController _acoContaminado10Controller = TextEditingController();
  final TextEditingController _acoContaminado20Controller = TextEditingController();
  final TextEditingController _papelaoController = TextEditingController();
  final TextEditingController _aluminio250Controller = TextEditingController();
  final TextEditingController _aluminio1Controller = TextEditingController();
  final TextEditingController _aluminio15Controller = TextEditingController();
  final TextEditingController _aco34Controller = TextEditingController();
  final TextEditingController _hidroxidoController = TextEditingController();
  final TextEditingController _acoNLController = TextEditingController();
  final TextEditingController _ibcController = TextEditingController();
  final TextEditingController _plasticoQuantidadeController = TextEditingController();
  final TextEditingController _plasticoQuilosController = TextEditingController();
  final TextEditingController _rigida1Controller = TextEditingController();
  final TextEditingController _rigida5Controller = TextEditingController();
  final TextEditingController _rigida10Controller = TextEditingController();
  final TextEditingController _rigida20Controller = TextEditingController();
  final TextEditingController _obsController = TextEditingController();

  final CollectionReference embalagemCollection = FirebaseFirestore.instance.collection('embalagens');

  Future<void> cadastrarEmbalagem() async {
    if (_formKey.currentState!.validate()) {
      try {
        await embalagemCollection.add({
          'data': _dataController.text,
          'hora': _horaController.text,
          'entregador': _entregadorController.text,
          'produtor': _produtorController.text,
          'telefone': _telefoneController.text,
          'placa': _placaController.text,
          'propriedade': _propriedadeController.text,
          'cnpj': _cnpjController.text,
          'endereco': _enderecoController.text,
          'pead250': _pead250Controller.text,
          'pead1': _pead1Controller.text,
          'pead5': _pead5Controller.text,
          'pead10': _pead10Controller.text,
          'pead20': _pead20Controller.text,
          'coex250': _coex250Controller.text,
          'coex1': _coex1Controller.text,
          'coex5': _coex5Controller.text,
          'coex10': _coex10Controller.text,
          'coex20': _coex20Controller.text,
          'tampas': _tampasController.text,
          'plasticoMisto1': _plasticoMisto1Controller.text,
          'plasticoMisto5': _plasticoMisto5Controller.text,
          'plasticoMisto10': _plasticoMisto10Controller.text,
          'plasticoMisto20': _plasticoMisto20Controller.text,
          'acoContaminado1': _acoContaminado1Controller.text,
          'acoContaminado5': _acoContaminado5Controller.text,
          'acoContaminado10': _acoContaminado10Controller.text,
          'acoContaminado20': _acoContaminado20Controller.text,
          'papelao': _papelaoController.text,
          '_aluminio250': _aluminio250Controller.text,
          '_aluminio1': _aluminio1Controller.text,
          '_aluminio15': _aluminio15Controller.text,
          '_aco34': _aco34Controller.text,
          'hidroxido': _hidroxidoController.text,
          'acoNL': _acoNLController.text,
          'ibc': _ibcController.text,
          'plasticoQuantidade': _plasticoQuantidadeController.text,
          'plasticoQuilos': _plasticoQuilosController.text,
          'rigida1': _rigida1Controller.text,
          'rigida5': _rigida5Controller.text,
          'rigida10': _rigida10Controller.text,
          'rigida20': _rigida20Controller.text,
          'obs': _obsController.text,
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Recebimento de embalagens",
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
                                  controller: _dataController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "dd/mm/aa", "Data"),
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira uma data';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _horaController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "hh:mm", "Hora"),
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira uma hora';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _entregadorController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "nome do entregador", "Entregador"),
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
                                  controller: _placaController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "placa do veículo", "Placa"),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira uma placa';
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Laváveis lavadas",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "PEAD",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _pead250Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "250 ml"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _pead1Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1 Litro"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _pead5Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "5 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _pead10Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "10 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _pead20Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "20 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "COEX",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _coex250Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "250 ml"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _coex1Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1 Litro"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _coex5Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "5 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _coex10Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "10 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _coex20Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "20 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Tampas",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _tampasController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade em quilos", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Contaminadas",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Plástico Misto",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _plasticoMisto1Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1 Litro"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _plasticoMisto5Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "5 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _plasticoMisto10Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "10 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _plasticoMisto20Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "20 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Aço",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _acoContaminado1Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1 Litro"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _acoContaminado5Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "5 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _acoContaminado10Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "10 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _acoContaminado20Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "20 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Não Contaminadas",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Papelão",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _papelaoController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade em quilos", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Alumínio",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _aluminio250Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "250g"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _aluminio1Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1Kg"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _aluminio15Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1,5Kg"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Aço(3,4Kg)",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _aco34Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Resíduo Inerte - Hidróxido de Alumínio",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _hidroxidoController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Não Laváveis",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Aço",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _acoNLController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "IBC",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _ibcController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Plástico Flexível",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _plasticoQuantidadeController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "Quantidade"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _plasticoQuilosController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "Quilos"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Tratamento de Semente - Plástica Rígida",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _rigida1Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "1 Litro"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _rigida5Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "5 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _rigida10Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "10 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _rigida20Controller,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira uma quantidade", "20 Litros"),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Observações:",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.verde,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  controller: _obsController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "insira as observações", ""),
                                  keyboardType: TextInputType.text,
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
                              await embalagemCollection.add({
                                'data': _dataController.text,
                                'hora': _horaController.text,
                                'entregador': _entregadorController.text,
                                'produtor': _produtorController.text,
                                'telefone': _telefoneController.text,
                                'placa': _placaController.text,
                                'propriedade': _propriedadeController.text,
                                'cnpj': _cnpjController.text,
                                'endereco': _enderecoController.text,
                                'pead250': _pead250Controller.text,
                                'pead1': _pead1Controller.text,
                                'pead5': _pead5Controller.text,
                                'pead10': _pead10Controller.text,
                                'pead20': _pead20Controller.text,
                                'coex250': _coex250Controller.text,
                                'coex1': _coex1Controller.text,
                                'coex5': _coex5Controller.text,
                                'coex10': _coex10Controller.text,
                                'coex20': _coex20Controller.text,
                                'tampas': _tampasController.text,
                                'plasticoMisto1': _plasticoMisto1Controller.text,
                                'plasticoMisto5': _plasticoMisto5Controller.text,
                                'plasticoMisto10': _plasticoMisto10Controller.text,
                                'plasticoMisto20': _plasticoMisto20Controller.text,
                                'acoContaminado1': _acoContaminado1Controller.text,
                                'acoContaminado5': _acoContaminado5Controller.text,
                                'acoContaminado10': _acoContaminado10Controller.text,
                                'acoContaminado20': _acoContaminado20Controller.text,
                                'papelao': _papelaoController.text,
                                '_aluminio250': _aluminio250Controller.text,
                                '_aluminio1': _aluminio1Controller.text,
                                '_aluminio15': _aluminio15Controller.text,
                                '_aco34': _aco34Controller.text,
                                'hidroxido': _hidroxidoController.text,
                                'acoNL': _acoNLController.text,
                                'ibc': _ibcController.text,
                                'plasticoQuantidade': _plasticoQuantidadeController.text,
                                'plasticoQuilos': _plasticoQuilosController.text,
                                'rigida1': _rigida1Controller.text,
                                'rigida5': _rigida5Controller.text,
                                'rigida10': _rigida10Controller.text,
                                'rigida20': _rigida20Controller.text,
                                'obs': _obsController.text,
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
