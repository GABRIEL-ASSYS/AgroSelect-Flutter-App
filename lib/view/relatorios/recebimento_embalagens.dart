import 'package:addcs/themes.dart';
import 'package:addcs/view/components/primary_button.dart';
import 'package:addcs/view/menu/menu.dart';
import 'package:addcs/view/relatorios/relatorios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
var cnpjMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 2) {
      newText = newText.substring(0, 2) + '/' + newText.substring(2);
    }
    if (newText.length > 5) {
      newText = newText.substring(0, 5) + '/' + newText.substring(5);
    }

    TextSelection newSelection =
        TextSelection.collapsed(offset: newText.length);

    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 2) {
      newText = newText.substring(0, 2) + ':' + newText.substring(2);
    }

    TextSelection newSelection =
        TextSelection.collapsed(offset: newText.length);

    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}

class RecebimentoEmbalagensScreen extends StatefulWidget {
  const RecebimentoEmbalagensScreen({super.key});

  @override
  State<RecebimentoEmbalagensScreen> createState() =>
      _RecebimentoEmbalagensScreenState();
}

class _RecebimentoEmbalagensScreenState
    extends State<RecebimentoEmbalagensScreen> {
  @override
  void initState() {
    super.initState();
    fetchEntregadores();
  }

  List<Map<String, dynamic>> entregadores = [];

  Future<void> fetchEntregadores() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('entregadores').get();

      setState(() {
        entregadores = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'nome': doc['nome'],
          };
        }).toList();
      });
    } catch (e) {
      print("Erro ao buscar entregadores: $e");
    }
  }

  String? _selectedEntregadorId;

  Future<void> fetchEntregadorData(String entregadorId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('entregadores')
          .doc(entregadorId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        _entregadorController.text = data['nome'] ?? '';
        _produtorController.text = data['produtor'] ?? '';
        _telefoneController.text = data['telefone'] ?? '';
        _propriedadeController.text = data['propriedade'] ?? '';
        _cnpjController.text = data['cnpj'] ?? '';
        _enderecoController.text = data['endereco'] ?? '';
      }
    } catch (e) {
      print("Erro ao buscar dados do entregador: $e");
    }
  }

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
  final TextEditingController _pead250Controller =
      TextEditingController(text: '0');
  final TextEditingController _pead1Controller =
      TextEditingController(text: '0');
  final TextEditingController _pead5Controller =
      TextEditingController(text: '0');
  final TextEditingController _pead10Controller =
      TextEditingController(text: '0');
  final TextEditingController _pead20Controller =
      TextEditingController(text: '0');
  final TextEditingController _coex250Controller =
      TextEditingController(text: '0');
  final TextEditingController _coex1Controller =
      TextEditingController(text: '0');
  final TextEditingController _coex5Controller =
      TextEditingController(text: '0');
  final TextEditingController _coex10Controller =
      TextEditingController(text: '0');
  final TextEditingController _coex20Controller =
      TextEditingController(text: '0');
  final TextEditingController _tampasController =
      TextEditingController(text: '0');
  final TextEditingController _plasticoMisto1Controller =
      TextEditingController(text: '0');
  final TextEditingController _plasticoMisto5Controller =
      TextEditingController(text: '0');
  final TextEditingController _plasticoMisto10Controller =
      TextEditingController(text: '0');
  final TextEditingController _plasticoMisto20Controller =
      TextEditingController(text: '0');
  final TextEditingController _acoContaminado1Controller =
      TextEditingController(text: '0');
  final TextEditingController _acoContaminado5Controller =
      TextEditingController(text: '0');
  final TextEditingController _acoContaminado10Controller =
      TextEditingController(text: '0');
  final TextEditingController _acoContaminado20Controller =
      TextEditingController(text: '0');
  final TextEditingController _papelaoController =
      TextEditingController(text: '0');
  final TextEditingController _aluminio250Controller =
      TextEditingController(text: '0');
  final TextEditingController _aluminio1Controller =
      TextEditingController(text: '0');
  final TextEditingController _aluminio15Controller =
      TextEditingController(text: '0');
  final TextEditingController _aco34Controller =
      TextEditingController(text: '0');
  final TextEditingController _hidroxidoController =
      TextEditingController(text: '0');
  final TextEditingController _acoNLController =
      TextEditingController(text: '0');
  final TextEditingController _ibcController = TextEditingController(text: '0');
  final TextEditingController _plasticoQuantidadeController =
      TextEditingController(text: '0');
  final TextEditingController _plasticoQuilosController =
      TextEditingController(text: '0');
  final TextEditingController _rigida1Controller =
      TextEditingController(text: '0');
  final TextEditingController _rigida5Controller =
      TextEditingController(text: '0');
  final TextEditingController _rigida10Controller =
      TextEditingController(text: '0');
  final TextEditingController _rigida20Controller =
      TextEditingController(text: '0');
  final TextEditingController _obsController = TextEditingController();

  final CollectionReference embalagemCollection =
      FirebaseFirestore.instance.collection('embalagens');

  bool _isLoading = false;

  String? _selectedType = 'CPF';

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##)#####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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

        await _showSuccessDialog(context);

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
            title: Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
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
                                  child: DropdownButtonFormField<String>(
                                    decoration: AppInputs.newInputDecoration("Selecione o Entregador", "Entregador"),
                                    style: AppInputs.textDecoration,
                                    value: _selectedEntregadorId,
                                    items: entregadores.map((entregador) {
                                      return DropdownMenuItem<String>(
                                        value: entregador['id'],
                                        child: Text(entregador['nome']),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedEntregadorId = newValue;
                                      });
                                      if (newValue != null) {
                                        fetchEntregadorData(newValue);
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                                    dropdownColor: Colors.white,
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: TextFormField(
                                      controller: _dataController,
                                      style: AppInputs.textDecoration,
                                      decoration: AppInputs.newInputDecoration(
                                          "dd/mm/aa", "Data"),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [DateInputFormatter()],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira uma data';
                                        }
                                        if (!RegExp(r'^\d{2}/\d{2}/\d{4}$')
                                            .hasMatch(value)) {
                                          return 'Data inválida';
                                        }
                                        return null;
                                      },
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: TextFormField(
                                    controller: _horaController,
                                    style: AppInputs.textDecoration,
                                    decoration: AppInputs.newInputDecoration(
                                        "hh:mm", "Hora"),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [TimeInputFormatter()],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma hora';
                                      }
                                      if (!RegExp(r'^\d{2}:\d{2}$')
                                          .hasMatch(value)) {
                                        return 'Hora inválida';
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
                                    readOnly: true,
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
                                    readOnly: true,
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
                                    readOnly: true,
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
                                    controller: _placaController,
                                    style: AppInputs.textDecoration,
                                    decoration: AppInputs.newInputDecoration(
                                        "placa do veículo", "Placa"),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma placa';
                                      } else if (value.length != 7 &&
                                          value.length != 8) {
                                        return 'A placa deve ter 7 ou 8 caracteres';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[A-Za-z0-9]')),
                                      LengthLimitingTextInputFormatter(8),
                                    ],
                                    maxLength: 8,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: TextFormField(
                                    controller: _propriedadeController,
                                    style: AppInputs.textDecoration,
                                    decoration: AppInputs.newInputDecoration(
                                        "nome da propriedade", "Propriedade"),
                                    readOnly: true,
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
                                        readOnly: true,
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
                                    readOnly: true,
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
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    "250 ml",
                                    style: TextStyle(
                                      fontSize: 25,
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    "1 Litro",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.verde,
                                    ),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                        "insira uma quantidade em quilos",
                                        "Quilos"),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                        "insira uma quantidade em quilos",
                                        "Quilos"),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira uma quantidade';
                                      }
                                      return null;
                                    },
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
                            PrimaryButton(
                                text: 'Cadastrar',
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      await embalagemCollection.add({
                                        'data': _dataController.text,
                                        'hora': _horaController.text,
                                        'entregador':
                                            _entregadorController.text,
                                        'produtor': _produtorController.text,
                                        'telefone': _telefoneController.text,
                                        'placa': _placaController.text,
                                        'propriedade':
                                            _propriedadeController.text,
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
                                        'plasticoMisto1':
                                            _plasticoMisto1Controller.text,
                                        'plasticoMisto5':
                                            _plasticoMisto5Controller.text,
                                        'plasticoMisto10':
                                            _plasticoMisto10Controller.text,
                                        'plasticoMisto20':
                                            _plasticoMisto20Controller.text,
                                        'acoContaminado1':
                                            _acoContaminado1Controller.text,
                                        'acoContaminado5':
                                            _acoContaminado5Controller.text,
                                        'acoContaminado10':
                                            _acoContaminado10Controller.text,
                                        'acoContaminado20':
                                            _acoContaminado20Controller.text,
                                        'papelao': _papelaoController.text,
                                        '_aluminio250':
                                            _aluminio250Controller.text,
                                        '_aluminio1': _aluminio1Controller.text,
                                        '_aluminio15':
                                            _aluminio15Controller.text,
                                        '_aco34': _aco34Controller.text,
                                        'hidroxido': _hidroxidoController.text,
                                        'acoNL': _acoNLController.text,
                                        'ibc': _ibcController.text,
                                        'plasticoQuantidade':
                                            _plasticoQuantidadeController.text,
                                        'plasticoQuilos':
                                            _plasticoQuilosController.text,
                                        'rigida1': _rigida1Controller.text,
                                        'rigida5': _rigida5Controller.text,
                                        'rigida10': _rigida10Controller.text,
                                        'rigida20': _rigida20Controller.text,
                                        'obs': _obsController.text,
                                      });

                                      await _showSuccessDialog(context);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RelatoriosScreen()),
                                      );
                                    } catch (e) {
                                      await showCustomAlertDialog(
                                        context,
                                        "Erro ao cadastrar: $e",
                                      );
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

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sair',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                )),
            content: const Text(
              'Todo conteúdo escrito não será salvo, você tem certeza que deseja sair?',
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
                  }),
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
        });
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
                      builder: (context) => const RelatoriosScreen(),
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
