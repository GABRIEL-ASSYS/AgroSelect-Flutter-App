import 'package:addcs/services/auth_service.dart';
import 'package:addcs/themes.dart';
import 'package:addcs/view/components/primary_button.dart';
import 'package:addcs/view/usuario/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

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
                Navigator.of(context).pop();
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
                      "Cadastre-se",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                        color: AppColors.verde,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
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
                                  "Seu Nome", "Nome"),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu nome';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: TextFormField(
                              controller: _emailController,
                              style: AppInputs.textDecoration,
                              decoration: AppInputs.newInputDecoration(
                                  "seuemail@dominio.com", "E-mail"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu e-mail';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Por favor, insira um e-mail válido';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Stack(
                              children: [
                                TextFormField(
                                  controller: _passwordController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "******", "Senha"),
                                  obscureText: _obscurePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira sua senha';
                                    }
                                    if (value.length < 8) {
                                      return 'A senha deve ter pelo menos 8 caracteres';
                                    }
                                    if (!value.contains(RegExp(r'[A-Z]'))) {
                                      return 'A senha deve conter pelo menos uma letra maiúscula';
                                    }
                                    return null;
                                  },
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Stack(
                              children: [
                                TextFormField(
                                  controller: _senhaController,
                                  style: AppInputs.textDecoration,
                                  decoration: AppInputs.newInputDecoration(
                                      "******", "Confirme a Senha"),
                                  obscureText: _obscureConfirmPassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, confirme sua senha';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'As senhas não coincidem';
                                    }
                                    return null;
                                  },
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                              ],
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
                              UserCredential userCredential = await _authService.cadastroUsuario(
                                nome: _nomeController.text,
                                email: _emailController.text,
                                senha: _passwordController.text,
                              );

                              if (userCredential.user != null) {
                                await _firestore.collection('users').doc(userCredential.user!.uid).set({
                                  'nome': _nomeController.text,
                                  'email': _emailController.text,
                                });

                                Fluttertoast.showToast(
                                  msg: "Cadastro realizado com sucesso!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  fontSize: 25,
                                  timeInSecForIosWeb: 3,
                                );

                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Erro ao criar usuário.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  fontSize: 25,
                                  timeInSecForIosWeb: 3,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'Erro: ${e.toString()}',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 25,
                                timeInSecForIosWeb: 3,
                              );
                              setState(() {
                                _isLoading = false;
                              });
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
                        },
                      ),
                    ],
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
