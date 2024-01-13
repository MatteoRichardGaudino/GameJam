// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:game_jam/buttons/KRoundButton.dart';
import 'package:game_jam/powerSlot.dart';

class WinScreen extends StatefulWidget {
  const WinScreen(this.onBackToMainTitle, {super.key});

  final dynamic Function() onBackToMainTitle;

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  bool ask = true;

  TextEditingController _textController = TextEditingController();
  bool buttonEnabled = false;

  @override
  void initState() {

    _textController.addListener(() {
      if(_textController.text.isNotEmpty){
        setState(() {
          buttonEnabled = true;
        });
      } else {
        setState(() {
          buttonEnabled = false;
        });
      }
    });

    super.initState();
  }

  static List<String> answers = [
    "As I see it, yes",
    "It is certain",
    "It is decidedly so",
    "Most likely",
    "Outlook good",
    "Signs point to yes",
    "Without a doubt",
    "Yes",
    "Yes – definitely",
    "You may rely on it",

    "Reply hazy, try again",
    "Ask again later",
    "Better not tell you now",
    "Cannot predict now",
    "Concentrate and ask again",

    "Don't count on it",
    "My reply is no",
    "My sources say no",
    "Outlook not so good",
    "Very doubtful",
  ];

  String _randomAnswer() {
    return answers[Random().nextInt(answers.length)];
  }

  Widget _askPage(){
    return Container(
      // width: _dialogWidth(),
      // height: _dialogHeight(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Text(
              "You are worthy of Kaalub's favour",
              style: TextStyle(
                fontSize: 45,
                color: Color(0xffF9EFC2),
                fontWeight: FontWeight.bold,
              )
          ),
          SizedBox(height: 50),
          Text(
              "Ask Kaalub your question about anything and get your divination",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffBCD1A0),
              )
          ),
          SizedBox(height: 5),
          Container(
            width: _textSize("Ask Kaalub your question about anything and get your divination", TextStyle(
              fontSize: 20,
              color: Color(0xffBCD1A0),
            )).width,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                // rounded corners
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
                //text color
                hintStyle: TextStyle(color: Color(0x7f3c0d1f)),
                hintText: 'Write your question here',
                // border color
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          KRoundButton(
              "Tell Me the Future",
            onPressed: buttonEnabled?  (){

                setState(() {
                  ask = false;
                });
              } : null,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _answerPage(){
    return Container(
      // width: _dialogWidth(),
      // height: _dialogHeight(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Text(
              "Kaalub says:",
              style: TextStyle(
                fontSize: 45,
                color: Color(0xffF9EFC2),
                fontWeight: FontWeight.bold,
              )
          ),
          SizedBox(height: 50),
          FadeIn(
            duration: Duration(seconds: 2),
            // Slow in fast out
            curve: Curves.easeInCubic,
            child: Text(
                _randomAnswer(),
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xffBCD1A0),
                )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 100),
              PowerSlot(true, width: 80,),
              SizedBox(width: 50),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: KRoundButton(
                    "Back to Main Title",
                    onPressed: widget.onBackToMainTitle,
                ),
              ),
              SizedBox(width: 50),
              PowerSlot(true, width: 80,),
              SizedBox(width: 100),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x7f3c0d1f),
      child: AlertDialog(
        backgroundColor: Color(0xff294543),
        surfaceTintColor: Color(0xff294543),
        content: ask? _askPage() : _answerPage(),
      ),
    );
  }


  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
