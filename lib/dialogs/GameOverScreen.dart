// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:game_jam/buttons/KRoundButton.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog(this.onYes, {super.key});


  final dynamic Function() onYes;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0x7f3c0d1f),
      child: AlertDialog(
        backgroundColor: Color(0xff294543),
        surfaceTintColor: Color(0xff294543),
        content: Container(
          // width: _dialogWidth(),
          // height: _dialogHeight(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                  "Game Over",
                  style: TextStyle(
                    fontSize: 45,
                    color: Color(0xffF9EFC2),
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 20),
              Text(
                  "You are not worthy of Kaalub's favour, \nbut she will surely enjoy feasting on your thoughts and desires.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffBCD1A0),
                  )
              ),
              SizedBox(height: 25),
              KRoundButton("Back to Main Title", onPressed: onYes),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}