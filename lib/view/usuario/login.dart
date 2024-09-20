import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:addcs/services/auth_service.dart';
import 'package:addcs/view/usuario/cadastro.dart';
import 'package:addcs/view/menu/menu.dart';
import 'package:addcs/themes.dart';
import '../components/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: AppBackground.boxDecoration,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.verde,
            toolbarHeight: 90,
            title: Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text(
                      "Login",
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
                          Stack(
                            children: [
                              TextFormField(
                                controller: _senhaController,
                                style: AppInputs.textDecoration,
                                decoration: AppInputs.newInputDecoration(
                                    "******", "Senha"),
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira sua senha';
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
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              onPressed: () async {
                                if (_emailController.text.isEmpty) {
                                  await showCustomAlertDialog(
                                    context,
                                    "Por favor, insira seu e-mail.",
                                  );
                                  return;
                                }

                                try {
                                  await FirebaseAuth.instance.sendPasswordResetEmail(
                                    email: _emailController.text,
                                  );

                                  await showCustomAlertDialog(
                                    context,
                                    "E-mail de redefinição de senha enviado.",
                                  );
                                } catch (e) {
                                  String errorMessage;
                                  if (e is FirebaseAuthException) {
                                    switch (e.code) {
                                      case 'user-not-found':
                                        await showCustomAlertDialog(
                                          context,
                                          "E-mail não cadastrado.",
                                        );
                                        break;
                                      default:
                                        await showCustomAlertDialog(
                                          context,
                                          "Erro ao enviar o e-mail. Tente novamente.",
                                        );
                                        break;
                                    }
                                  } else {
                                    await showCustomAlertDialog(
                                      context,
                                      "Ocorreu um erro. Tente novamente.",
                                    );
                                  }
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Esqueci a minha senha",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: AppColors.verde,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.green,
                                  ),
                                ),
                              ),
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
                      PrimaryButton(text: 'Entrar', onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            await _authService.loginUsuario(
                              email: _emailController.text,
                              senha: _senhaController.text,
                            );
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const MenuScreen()),
                                    (Route<dynamic> route) => false,
                              );
                            }
                          } catch (e) {
                            String errorMessage;
                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'user-not-found':
                                  await showCustomAlertDialog(
                                    context,
                                    "Seu email não está cadastrado.",
                                  );
                                  break;
                                case 'wrong-password':
                                  await showCustomAlertDialog(
                                    context,
                                    "Senha incorreta.",
                                  );
                                  break;
                                default:
                                  await showCustomAlertDialog(
                                    context,
                                    "Ocorreu um erro. Por favor, tente novamente.",
                                  );
                                  break;
                              }
                            } else {
                              await showCustomAlertDialog(
                                context,
                                "Ocorreu um erro. Por favor, tente novamente.",
                              );
                            }
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
                      const SizedBox(height: 20),
                      PrimaryButton(text: 'Cadastrar', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CadastroScreen()),
                        );
                      }),
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
