import 'package:addcs/screens/cadastro.dart';
import 'package:addcs/screens/components/primary_button.dart';
import 'package:addcs/screens/menu.dart';
import 'package:addcs/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:addcs/themes.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                            ),
                          ),
                          TextFormField(
                            controller: _senhaController,
                            style: AppInputs.textDecoration,
                            decoration:
                            AppInputs.newInputDecoration("******", "Senha"),
                            obscureText: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Esqueci a minha senha",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.verde,
                                  decoration: TextDecoration.underline,
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
                        try {
                          await _authService.loginUsuario(
                            email: _emailController.text,
                            senha: _senhaController.text,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MenuScreen()),
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
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
