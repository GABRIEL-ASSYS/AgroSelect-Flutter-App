import 'package:addcs/view/menu/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String _nome = '';
  String _email = '';

  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
        await showCustomAlertDialog(
          context,
          "Imagem carregada com sucesso.",
        );
      }
    } catch (e) {
      await showCustomAlertDialog(
        context,
        "Erro ao carregar a imagem: $e",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _nome = userDoc['nome'] ?? 'Nome não disponível';
          _email = userDoc['email'] ?? 'E-mail não disponível';
        });
      }
    } catch (e) {
      await showCustomAlertDialog(
        context,
        "Erro ao carregar dados do usuário: $e",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _alterarEmail() async {
    final TextEditingController _novoEmailController = TextEditingController();
    final TextEditingController _senhaController = TextEditingController();
    bool _obscureSenha = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Alterar E-mail',
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _novoEmailController,
                decoration: const InputDecoration(
                  labelText: 'Novo E-mail',
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _senhaController,
                obscureText: _obscureSenha,
                decoration: InputDecoration(
                  labelText: 'Senha Atual',
                  labelStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenha ? Icons.visibility_off : Icons.visibility,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureSenha = !_obscureSenha;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
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
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 50),
              ),
              onPressed: () async {
                String novoEmail = _novoEmailController.text;
                String senha = _senhaController.text;

                if (novoEmail.isEmpty || senha.isEmpty) {
                  await showCustomAlertDialog(
                    context,
                    "Por favor, insira o novo e-mail e a senha atual.",
                  );
                  return;
                }

                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: _user!.email!,
                    password: senha,
                  );
                  await _user!.reauthenticateWithCredential(credential);

                  await _user!.updateEmail(novoEmail);
                  await _user!.reload();
                  _user = _auth.currentUser;

                  await _firestore.collection('users').doc(_user!.uid).update({'email': novoEmail});

                  await showCustomAlertDialog(
                    context,
                    "E-mail alterado com sucesso.",
                  );
                } catch (e) {
                  await showCustomAlertDialog(
                    context,
                    "Erro ao alterar e-mail: $e",
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Confirmar',
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
  }

  Future<void> _alterarSenha() async {
    final TextEditingController _senhaAtualController = TextEditingController();
    final TextEditingController _novaSenhaController = TextEditingController();
    bool _obscureSenhaAtual = true;
    bool _obscureNovaSenha = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Alterar Senha',
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _senhaAtualController,
                obscureText: _obscureSenhaAtual,
                decoration: InputDecoration(
                  labelText: 'Senha Atual',
                  labelStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenhaAtual ? Icons.visibility_off : Icons.visibility,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureSenhaAtual = !_obscureSenhaAtual;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _novaSenhaController,
                obscureText: _obscureNovaSenha,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  labelStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNovaSenha ? Icons.visibility_off : Icons.visibility,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNovaSenha = !_obscureNovaSenha;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
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
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 50),
              ),
              onPressed: () async {
                String senhaAtual = _senhaAtualController.text;
                String novaSenha = _novaSenhaController.text;

                if (senhaAtual.isEmpty || novaSenha.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Por favor, insira a senha atual e a nova senha.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 25,
                    timeInSecForIosWeb: 3,
                  );
                  return;
                }

                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: _user!.email!,
                    password: senhaAtual,
                  );
                  await _user!.reauthenticateWithCredential(credential);

                  await _user!.updatePassword(novaSenha);

                  Fluttertoast.showToast(
                    msg: "Senha alterada com sucesso.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 25,
                    timeInSecForIosWeb: 3,
                  );
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Erro ao alterar senha: $e",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 25,
                    timeInSecForIosWeb: 3,
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Confirmar',
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
  }

  Future<void> _verificarEmail() async {
    if (_user != null) {
      try {
        await _user!.sendEmailVerification();
        Fluttertoast.showToast(
          msg: "E-mail de verificação enviado.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 25,
          timeInSecForIosWeb: 3,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Erro ao enviar e-mail de verificação.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 25,
          timeInSecForIosWeb: 3,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
                  builder: (context) => const MenuScreen()
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
        child: _isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path))
                      : null,
                  child: _image == null
                      ? Icon(
                    Icons.person,
                    size: 150,
                    color: Colors.grey[700],
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)), // Padding
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: const Text('Selecionar Foto', style: TextStyle(
                  fontSize: 25,
                )),
              ),
              const SizedBox(height: 20),
              Text(
                _nome,
                style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                _email,
                style: TextStyle(fontSize: 25, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: _alterarEmail,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                child: const Text(
                  'Alterar E-mail',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              TextButton(
                onPressed: _verificarEmail,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                child: const Text(
                  'Verificar E-mail',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              TextButton(
                onPressed: _alterarSenha,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                child: const Text(
                  'Alterar Senha',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
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
