import 'package:addcs/view/entregador/entregadores.dart';
import 'package:addcs/view/usuario/perfil.dart';
import 'package:addcs/themes.dart';
import 'package:addcs/view/entregador/cadastro_entregador.dart';
import 'package:addcs/view/components/secundary_button.dart';
import 'package:addcs/view/usuario/login.dart';
import 'package:addcs/view/relatorios/recebimento_embalagens.dart';
import 'package:addcs/view/relatorios/relatorios.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()
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
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right:16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    size: 55,
                    color: AppColors.branco,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PerfilScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SecundaryButton(
                    text: 'Recebimento de embalagens',
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RecebimentoEmbalagensScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  SecundaryButton(
                    text: 'Cadastro Entregador',
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CadastroEntregadorScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  SecundaryButton(
                    text: 'Relatórios de recebimento',
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RelatoriosScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  SecundaryButton(
                    text: 'Entregadores',
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const EntregadoresScreen()),
                      );
                    },
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