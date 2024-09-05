import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:addcs/services/auth_service.dart';
import 'package:addcs/view/cadastro.dart';
import 'package:addcs/view/menu.dart';
import 'package:addcs/themes.dart';
import 'components/primary_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: AppBackground.boxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
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
                                    color: Colors.grey,
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
                                  Fluttertoast.showToast(
                                    msg: "Por favor, insira seu e-mail.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 25,
                                    timeInSecForIosWeb: 3,
                                  );
                                  return;
                                }

                                try {
                                  await FirebaseAuth.instance.sendPasswordResetEmail(
                                    email: _emailController.text,
                                  );

                                  Fluttertoast.showToast(
                                    msg: "E-mail de redefinição de senha enviado.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 25,
                                    timeInSecForIosWeb: 3,
                                  );
                                } catch (e) {
                                  String errorMessage;
                                  if (e is FirebaseAuthException) {
                                    switch (e.code) {
                                      case 'user-not-found':
                                        errorMessage = 'E-mail não cadastrado.';
                                        break;
                                      default:
                                        errorMessage = 'Erro ao enviar o e-mail. Tente novamente.';
                                        break;
                                    }
                                  } else {
                                    errorMessage = 'Ocorreu um erro. Tente novamente.';
                                  }

                                  Fluttertoast.showToast(
                                    msg: errorMessage,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 25,
                                    timeInSecForIosWeb: 3,
                                  );
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
                          try {
                            await _authService.loginUsuario(
                              email: _emailController.text,
                              senha: _senhaController.text,
                            );
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MenuScreen()),
                              );
                            }
                          } catch (e) {
                            String errorMessage;
                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'user-not-found':
                                  errorMessage = 'Seu email não está cadastrado.';
                                  break;
                                case 'wrong-password':
                                  errorMessage = 'Senha incorreta.';
                                  break;
                                default:
                                  errorMessage = 'Ocorreu um erro. Por favor, tente novamente.';
                                  break;
                              }
                            } else {
                              errorMessage = 'Ocorreu um erro. Por favor, tente novamente.';
                            }
                            Fluttertoast.showToast(
                              msg: errorMessage,
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
}
