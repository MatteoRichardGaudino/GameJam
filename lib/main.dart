import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_jam/cardStack.dart';
import 'package:game_jam/demonHand.dart';
import 'package:game_jam/points.dart';
import 'package:game_jam/powerSlot.dart';
import 'package:playing_cards/playing_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double cardWidth = 0;
  double cardHeight = 0;

  final allCards = <PlayingCard>[
    PlayingCard(Suit.spades, CardValue.ace),
    PlayingCard(Suit.spades, CardValue.two),
    PlayingCard(Suit.spades, CardValue.three),
    PlayingCard(Suit.spades, CardValue.four),
    PlayingCard(Suit.spades, CardValue.five),
    PlayingCard(Suit.spades, CardValue.six),
    PlayingCard(Suit.spades, CardValue.seven),
    PlayingCard(Suit.spades, CardValue.eight),
    PlayingCard(Suit.spades, CardValue.nine),
    PlayingCard(Suit.spades, CardValue.ten),

    PlayingCard(Suit.hearts, CardValue.ace),
    PlayingCard(Suit.hearts, CardValue.two),
    PlayingCard(Suit.hearts, CardValue.three),
    PlayingCard(Suit.hearts, CardValue.four),
    PlayingCard(Suit.hearts, CardValue.five),
    PlayingCard(Suit.hearts, CardValue.six),
    PlayingCard(Suit.hearts, CardValue.seven),
    PlayingCard(Suit.hearts, CardValue.eight),
    PlayingCard(Suit.hearts, CardValue.nine),
    PlayingCard(Suit.hearts, CardValue.ten),

    PlayingCard(Suit.clubs, CardValue.ace),
    PlayingCard(Suit.clubs, CardValue.two),
    PlayingCard(Suit.clubs, CardValue.three),
    PlayingCard(Suit.clubs, CardValue.four),
    PlayingCard(Suit.clubs, CardValue.five),
    PlayingCard(Suit.clubs, CardValue.six),
    PlayingCard(Suit.clubs, CardValue.seven),
    PlayingCard(Suit.clubs, CardValue.eight),
    PlayingCard(Suit.clubs, CardValue.nine),
    PlayingCard(Suit.clubs, CardValue.ten),

    PlayingCard(Suit.diamonds, CardValue.ace),
    PlayingCard(Suit.diamonds, CardValue.two),
    PlayingCard(Suit.diamonds, CardValue.three),
    PlayingCard(Suit.diamonds, CardValue.four),
    PlayingCard(Suit.diamonds, CardValue.five),
    PlayingCard(Suit.diamonds, CardValue.six),
    PlayingCard(Suit.diamonds, CardValue.seven),
    PlayingCard(Suit.diamonds, CardValue.eight),
    PlayingCard(Suit.diamonds, CardValue.nine),
    PlayingCard(Suit.diamonds, CardValue.ten),
  ];
  final initialCards = <PlayingCard>[];

  final edgesStks = <List<PlayingCard>>[];
  final verticesStks = <List<PlayingCard>>[
    [],[],[],[]
  ];
  final demonHand1Stk = <PlayingCard>[];
  final demonHand2Stk = <PlayingCard>[];

  final discardStk = <PlayingCard>[];

  _MyHomePageState(){
    allCards.shuffle();

    // if one of the first 4 cards is an ace replace it with the first non-ace card
    for(int i = 0; i < 5; i++){
      if(allCards[i].value == CardValue.ace){
        for(int j = 5; j < allCards.length; j++){
          if(allCards[j].value != CardValue.ace){
            final temp = allCards[i];
            allCards[i] = allCards[j];
            allCards[j] = temp;
            break;
          }
        }
      }
    }

    initialCards.addAll(allCards.sublist(0, 5));
    allCards.removeRange(0, 5);

    gamePoints.onChange = (){
      setState(() {});
    };

    edgesStks.addAll([
      [initialCards[0]],
      [initialCards[1]],
      [initialCards[2]],
      [initialCards[3]],
      [initialCards[4]],
    ]);
  }

  // build three dots in a row
  Widget _buildPowerSlots(width){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        PowerSlot(gamePoints.can(1), width: width/3,),
        PowerSlot(gamePoints.can(2), width: width/3,),
        PowerSlot(gamePoints.can(3), width: width/3,),
      ],
    );
  }

  // build two container in a row
  Widget _buildDemonHand(){
    return Column(
      children: [
        CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: demonHand1Stk, type: CardStackType.demonHand),
        SizedBox(height: 20),
        CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: demonHand2Stk, type: CardStackType.demonHand)
      ],
    );
  }

  Widget _buildFirstCol(width){
    return Stack(
      clipBehavior: Clip.none,
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 1/4,
                child: _buildPowerSlots(width))),
        //Expanded(child: Spacer()),
        Positioned(
          bottom: -40,
            left: 0,
            child: DemonHand(width, cardHeight: cardHeight, cardWidth: cardWidth, stk1: demonHand1Stk, stk2: demonHand2Stk,))
        //_buildDemonHand(),
      ],
    );
  }


  // Build a 3x3 grid of cards
  Widget _buildBoard(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[0], type: CardStackType.vertex,),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[0], type: CardStackType.edge),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[1], type: CardStackType.vertex,),
            ],
          ),
        ),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[1], type: CardStackType.edge),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[2], type: CardStackType.edge),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[3], type: CardStackType.edge),
            ],
          ),
        ),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[2], type: CardStackType.vertex,),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[4], type: CardStackType.edge),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[3], type: CardStackType.vertex,),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThirdCol(width){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Spacer(),
        CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: discardStk, type: CardStackType.discard),
        SizedBox(height: 20),
        Visibility(
          visible: false,
          child: OutlinedButton(
            onPressed: (){
              _showDiscardPile();
            },
            child: Text("Summon card (2pp)"),
          ),
        ),
        SizedBox(height: 20),

        CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: allCards, type: CardStackType.deck),
        SizedBox(height: 40),
        OutlinedButton(
          onPressed: (){
            if(!gamePoints.can(2)) return;

            final index = allCards.indexWhere((element) => element.value == CardValue.ace);
            if(index == -1) return;
            final card = allCards.removeAt(index);
            print("Summoning an ace. index = $index, points = ${gamePoints.points}");

            for(int i = 0; i < verticesStks.length; i++){
              if(verticesStks[i].isEmpty){
                verticesStks[i].add(card);
                gamePoints.dec(2);
                break;
              }
            }
          },
          child: Text("Summon an Ace (2pp)"),
        ),
        Spacer()
      ],
    );
  }

  void _showDiscardPile(){
    final stk = allCards;

    int start = 0;
    int end = min(stk.length, 10);

    final firstRow = stk.sublist(start, end);
    start = end;
    end = min(stk.length, 20);
    final secondRow = stk.sublist(start, end);
    start = end;
    end = stk.length;
    final thirdRow = stk.sublist(start, end);

    print("firstRowSize: ${firstRow.length}");
    print("secondRowSize: ${secondRow.length}");
    print("thirdRowSize: ${thirdRow.length}");


    final dialogWidth = MediaQuery.of(context).size.width * 2/3;
    final dialogHeight = MediaQuery.of(context).size.height * 2/3;

    double frstRowOffset = 0;
    double firstRowSpace =  ((dialogWidth -80)/ firstRow.length);

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Discard pile"),
          content: Container(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(),
                    ...firstRow.map((e) =>
                        Transform.translate(
                          offset: Offset(frstRowOffset++ * (firstRowSpace), 0),
                          child: Container(
                            width: cardWidth,
                            height: cardHeight,
                            child: PlayingCardView(card: e),
                          ),
                        )
                    ).toList()
                  ],
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.red,
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.red,
                    )
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final first = screenWidth * 1/4;
    final second = screenWidth * 2/4;
    final third = screenWidth * 1/4;

    // if(second < screenHeight){
    //   // print("second < screenHeight");
    //   cardWidth = second/4;
    //   cardHeight = cardWidth * 3/2;
    // } else {
      // print("second > screenHeight");
      cardHeight = screenHeight/4;
      cardWidth = cardHeight * 2/3;
    // }

    // print("cardWidth = $cardWidth");
    // print("cardHeight = $cardHeight");
    // print("AspectRatio = ${cardWidth/cardHeight}, (2:3 = ${2/3})");

    return Scaffold(
      body: Container(
        color: Color(0xff171F22),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: first,
                height: screenHeight,
                child: _buildFirstCol(first)
            ),
            Container(width: second,
                height: screenHeight,
                alignment: Alignment.center,
                child: _buildBoard()),
            Container(width: third,
                height: screenHeight,child: _buildThirdCol(third)),
          ],
        ),
      )
    );
  }
}
