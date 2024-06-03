import 'package:addcs/screens/cadastro.dart';
import 'package:addcs/screens/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:addcs/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
                              style: AppInputs.textDecoration,
                              decoration: AppInputs.newInputDecoration(
                                  "seuemail@dominio.com", "E-mail"),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          TextFormField(
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
                      PrimaryButton(text: 'Entrar', onTap: () {}),
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
