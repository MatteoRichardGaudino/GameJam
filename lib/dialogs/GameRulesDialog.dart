// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:game_jam/buttons/KRoundButton.dart';

class GameRulesDialog extends StatelessWidget {
  const GameRulesDialog({super.key});


  @override
  Widget build(BuildContext context) {

    final scrollController = ScrollController();

    return Container(
      color: Color(0x7f3c0d1f),
      child: AlertDialog(
        backgroundColor: Color(0xff294543),
        surfaceTintColor: Color(0xff294543),
        content: Container(
          width: _dialogWidth(context),
          height: _dialogHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  Text("Game Rules", style: TextStyle(
                      color: Color(0xffF9EFC2),
                      fontWeight: FontWeight.bold,
                      fontSize: 40),),

                  Spacer(),
                  KRoundButton("X", circular: true, onPressed: (){
                    Navigator.of(context).pop();
                  },),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  // height: _dialogHeight(context) * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thumbColor: Color(0xffF9EFC2),
                    radius: Radius.circular(30),
                    controller: scrollController,
                    thickness: 8,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Container(),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. ",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. ",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. ",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. ",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl vitae nisl. ",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  double _dialogWidth(context) => MediaQuery.of(context).size.width * 0.8;
  double _dialogHeight(context) => MediaQuery.of(context).size.width * 0.8;

}

