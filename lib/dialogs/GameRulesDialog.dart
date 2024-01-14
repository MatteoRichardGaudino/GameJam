// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:game_jam/buttons/KRoundButton.dart';

class GameRulesDialog extends StatelessWidget {
   GameRulesDialog({super.key});


  final Color green = Color(0xffBCD1A0);
  final Color yellow = Color(0xffE7B884);


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
                          "A 40-card deck is used with 4 suits (mirrors, hearts, spectres, eyes) and 10 cards per suit (ranging from Ace to King).\n"+
                          "The preparation consists, after random shuffling, of forming a cross of 5 uncovered cards in the centre of the table. The empty spots in the four corners of the cross will serve as space for the Aces.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffE7B884),
                            fontSize: 20,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Color(0xffBCD1A0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                text: "The aim of the game is to stack all the cards of each suit in ascending order "
                              ),
                              TextSpan(
                                style: TextStyle(
                                  color: Color(0xffBCD1A0),
                                  fontSize: 20,
                                ),
                                text: "(Ace, 2, 3, 4, 5, 6, 7, Page, Knight, King), "
                              ),
                              TextSpan(
                                  style: TextStyle(
                                    color: Color(0xffBCD1A0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                text: "starting with the Aces that are placed in the corners of the cross. Every time a card is put on top of another card in the cross, the player obtains 1 Sorcery Point."
                              )
                            ]
                          ),
                          style: TextStyle(
                            color: Color(0xffE7B884),
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "If the player takes a card from the top of the draw pile he/she must choose to either:\n1.  Discard the card\n2. Place the card on the board\n3. Give the card to Kaalub’s Hand (at a cost of 1 Sorcery Points)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffE7B884),
                            fontSize: 20,
                          ),
                        ),

                        SizedBox(height: 10),

                        // There are 3 moves allowed:
                        Text(
                          "There are 3 moves allowed:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(fontWeight: FontWeight.bold,),
                                    text: "A. Move any face-up card "
                                ),
                                TextSpan(
                                    text: "(from the top of the discard pile, drawn from the draw pile, already present within one of the 5 positions of the cross, or a card from Kaalub’s Hand)"
                                ),
                                TextSpan(
                                    style: TextStyle(fontWeight: FontWeight.bold,),
                                    text: " over another card in one of the 5 positions of the cross if of the same suit and always in descending order "
                                ),
                                TextSpan(
                                    text: "(e.g. the 6 of Hearts can only be placed over the 7 of Hearts);"
                                ),
                                TextSpan(
                                    style: TextStyle(fontWeight: FontWeight.bold,),
                                    text: "\nB. Move any face-up card  to an empty space formed in one of the 5 positions of the cross;"
                                ),
                                TextSpan(
                                    style: TextStyle(fontWeight: FontWeight.bold,),
                                    text: "\nC. Move any face-up card on top of another card in one of the 4 corners designated for the Aces of each suit, if it is of the same suit as the relevant stack and always in ascending order"
                                ),
                                TextSpan(
                                    text: " (e.g. the 5 of Eyes may only be placed on top of the 4 of Eyes)."
                                ),

                              ]
                          ),
                          style: TextStyle(
                            color: yellow,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),


                        SizedBox(height: 10),
                        // The Sorcery points
                        Text(
                          "The Sorcery Points:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "You gain "),
                              TextSpan(text: "1 ", style: TextStyle(fontWeight: FontWeight.bold, color: green)),
                              TextSpan(text: "each time you manage to make an  "),
                              TextSpan(text: "A. Move ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "i.e. when you move any uncovered card over another card in one of the 5 cross positions. "),
                            ]
                          ),
                          style: TextStyle(
                            color: yellow,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(text: "SP are used for "),
                                TextSpan(text: "'special actions' ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "that the player can perform in order to win the game. There are 3 of these: "),
                              ]
                          ),
                          style: TextStyle(
                            color: yellow,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(text: "At a cost of ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "1 ", style: TextStyle(fontWeight: FontWeight.bold, color: green)),
                                TextSpan(text: "SP you can choose any uncovered card and add it to Kaalub’s Hand: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "a space where you can keep up to 2 cards to play later; "),
                              ]
                          ),
                          style: TextStyle(
                            color: yellow,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(text: "At a cost of ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "2 ", style: TextStyle(fontWeight: FontWeight.bold, color: green)),
                                TextSpan(text: "SPs you can 'Summon an Ace' from the draw pile: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "the Ace in question will be the first in order of draw, and will be immediately played on the board."),
                              ]
                          ),
                          style: TextStyle(
                            color: yellow,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(text: "At a cost of ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "2 ", style: TextStyle(fontWeight: FontWeight.bold, color: green)),
                                TextSpan(text: "SPs and only once in the whole game, you may take any card from the discard pile ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "and place it on the top of your discard pile. "),
                              ]
                          ),
                          style: TextStyle(
                            color: yellow,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
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

