import 'package:addcs/themes.dart';
import 'package:flutter/material.dart';

class RecebimentoEmbalagensScreen extends StatefulWidget {
  const RecebimentoEmbalagensScreen({super.key});

  @override
  State<RecebimentoEmbalagensScreen> createState() => _RecebimentoEmbalagensScreenState();
}

class _RecebimentoEmbalagensScreenState extends State<RecebimentoEmbalagensScreen> {
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
