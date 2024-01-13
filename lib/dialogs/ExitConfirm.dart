// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:game_jam/buttons/KRoundButton.dart';

class ExitConfirmDialog extends StatelessWidget {
  const ExitConfirmDialog(this.onYes, {super.key});


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
                  "Exit Game",
                  style: TextStyle(
                    fontSize: 45,
                    color: Color(0xffF9EFC2),
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 20),
              Text(
                  "Are you sure you want to leave the game?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffBCD1A0),
                  )
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KRoundButton("Yes", onPressed: onYes),
                  SizedBox(width: 50),
                  KRoundButton("No", onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
