import 'package:addcs/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                    SecundaryButtonProperties
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
