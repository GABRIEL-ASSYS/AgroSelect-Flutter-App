
import 'package:addcs/themes.dart';
import 'package:addcs/view/cadastro_entregador.dart';
import 'package:addcs/view/components/secundary_button.dart';
import 'package:addcs/view/recebimento_embalagens.dart';
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
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 55,
                  color: AppColors.verde,
                ),
              ),
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
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
