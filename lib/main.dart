// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:game_jam/AudioManager.dart';
import 'package:game_jam/buttons/KIconButton.dart';
import 'package:game_jam/dialogs/ExitConfirm.dart';
import 'package:game_jam/dialogs/GameOverScreen.dart';
import 'package:game_jam/dialogs/GameRulesDialog.dart';
import 'package:game_jam/dialogs/WinScreen.dart';
import 'package:game_jam/buttons/KRoundButton.dart';
import 'package:game_jam/cardStack.dart';
import 'package:game_jam/demonHand.dart';
import 'package:game_jam/buttons/kTextButton.dart';
import 'package:game_jam/points.dart';
import 'package:game_jam/powerSlot.dart';
import 'package:hovering/hovering.dart';
import 'package:playing_cards/playing_cards.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

enum GameState{
  playing,
  won,
  lost
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaalub',
      theme: ThemeData(
        fontFamily: "Sahitya",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainTitle(),
    );
  }
}

class MainTitle extends StatefulWidget {
  const MainTitle({super.key});

  @override
  State<MainTitle> createState() => _MainTitleState();
}

class _MainTitleState extends State<MainTitle> {
  
  bool startGame = false;

  Widget _buildTitle(){
    return GestureDetector(
        onTapDown: (a){
          audioManager.playMenu();
        },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xff171F22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/Main_Title_start.png",
                height: MediaQuery.of(context).size.height * 2/3,
              ),
              Spacer(flex: 1,),
              KRoundButton("Start Game", fontSize: 50,
                onPressed: (){
                  setState(() {
                    startGame = true;
                    audioManager.stopMenu().then((value) => audioManager.playGameMusic());
                  });
                },
              ),
              Spacer(flex: 2,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainGame(){
    return FadeIn(
      duration: Duration(milliseconds: 500),
      child: MainGame(() {
        setState(() {
          startGame = false;
          audioManager.stopGameMusic().then((value) => audioManager.playMenu());
        });
      }),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff171F22),
        child: startGame? _buildMainGame() : _buildTitle(),
      );
  }
}


class MainGame extends StatefulWidget {
  const MainGame(this.onBack, {super.key});

  final dynamic Function()? onBack;

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> with TickerProviderStateMixin{

  double cardWidth = 0;
  double cardHeight = 0;

  final allCards = <PlayingCard>[];
  final initialCards = <PlayingCard>[];

  final edgesStks = <List<PlayingCard>>[];
  final verticesStks = <List<PlayingCard>>[];
  final demonHand1Stk = <PlayingCard>[];
  final demonHand2Stk = <PlayingCard>[];

  final discardStk = <PlayingCard>[];

  bool canSummon = true;

  bool mainMusicOff = true;

  void _reset(){
    allCards.clear();
    initialCards.clear();
    edgesStks.clear();
    verticesStks.clear();
    demonHand1Stk.clear();
    demonHand2Stk.clear();
    discardStk.clear();
    canSummon = true;
    gamePoints.reset();

    allCards.addAll([PlayingCard(Suit.spades, CardValue.ace),
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
      PlayingCard(Suit.diamonds, CardValue.ten),]);
    verticesStks.addAll([
      [],
      [],
      [],
      [],
    ]);

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
      // [PlayingCard(Suit.clubs, CardValue.four)],
      // [PlayingCard(Suit.clubs, CardValue.two)],
      // [PlayingCard(Suit.clubs, CardValue.three)],
      // [],
      // [],
    ]);
  }

  @override
  void initState() {
    super.initState();


    _reset();
  }



  GameState _winCheck(){
    // if all the vertex has a 10 return won
    if(verticesStks.every((element) => element.isNotEmpty && element.last.value == CardValue.ten)){
      return GameState.won;
    }
    // if the deck is not empty return playing
    if(allCards.isNotEmpty) return GameState.playing; // this includes the case where can summon an ace is true

    // if demon hand has space and points can 1 return playing
    if((demonHand1Stk.isEmpty || demonHand2Stk.isEmpty) && gamePoints.can(1)) return GameState.playing;

    // if can move a card from discard to board return playing
    if(discardStk.isNotEmpty){
      final card = discardStk.last;
      if(edgesStks.any((element) => element.isEmpty || descRule(element.last, card))) return GameState.playing;
      if(verticesStks.any((element) => (element.isEmpty && card.value == CardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
    }
    // same thing for demon hand
    if(demonHand1Stk.isNotEmpty){
      final card = demonHand1Stk.last;
      if(edgesStks.any((element) => element.isEmpty || descRule(element.last, card))) return GameState.playing;
      if(verticesStks.any((element) => (element.isEmpty && card.value == CardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
    }
    if(demonHand2Stk.isNotEmpty){
      final card = demonHand2Stk.last;
      if(edgesStks.any((element) => element.isEmpty || descRule(element.last, card))) return GameState.playing;
      if(verticesStks.any((element) => (element.isEmpty && card.value == CardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
    }
    // if can move a card from the edges to the vertices return playing
    for(int i = 0; i < edgesStks.length; i++){
      final stk = edgesStks[i];
      if(stk.isNotEmpty) {
        final card = edgesStks[i].last;
        if(verticesStks.any((element) => (element.isEmpty && card.value == CardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
      }
    }
    // if can move a card from the edges to the edges return playing
    for(int i = 0; i < edgesStks.length; i++){
      final stk = edgesStks[i];
      if(stk.isNotEmpty) {
        final card = edgesStks[i].last;
        if(edgesStks.any((element) => element != stk && (element.isEmpty || descRule(element.last, card)))) return GameState.playing;
      }
    }

    // if can summon a card return playing
    if(canSummon && gamePoints.can(2) && discardStk.isNotEmpty) return GameState.playing;


    return GameState.lost;
  }

  void _winCheckAndSetState(){
    final state = _winCheck();
    if(state == GameState.playing) return;

    if(state == GameState.won){
      _showWinDialog();
    } else {
      _showGameOverDialog();
    }
  }

  void _showWinDialog(){
    showDialog(context: context, builder: (context){
      return WinScreen((){
        Navigator.pop(context);
        widget.onBack?.call();
      });
    });
  }

  void _showExitConfirmDialog(){
    showDialog(context: context, builder: (context){
      return ExitConfirmDialog((){
        Navigator.pop(context);
        widget.onBack?.call();
      });
    });
  }

  void _showGameOverDialog(){
    showDialog(context: context, builder: (context){
      return GameOverDialog(() => {
        Navigator.pop(context),
        widget.onBack?.call()
      });
    });
  }

  void _showGameRules(){
    showDialog(context: context, builder: (context){
      return GameRulesDialog();
    });
  }

  // build three dots in a row
  Widget _buildPowerSlots(width){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        PowerSlot(gamePoints.can(1), width: width/3,),
        PowerSlot(gamePoints.can(2), width: width/3,),
        PowerSlot(gamePoints.can(3), width: width/3,),
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
            child: DemonHand(width, cardHeight: cardHeight, cardWidth: cardWidth, stk1: demonHand1Stk, stk2: demonHand2Stk, onAccept: _winCheckAndSetState,))
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
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[0], type: CardStackType.vertex, onAccept: _winCheckAndSetState),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[0], type: CardStackType.edge, onAccept: _winCheckAndSetState),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[1], type: CardStackType.vertex, onAccept: _winCheckAndSetState),
            ],
          ),
        ),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[1], type: CardStackType.edge, onAccept: _winCheckAndSetState),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[2], type: CardStackType.edge, onAccept: _winCheckAndSetState),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[3], type: CardStackType.edge, onAccept: _winCheckAndSetState),
            ],
          ),
        ),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[2], type: CardStackType.vertex,onAccept: _winCheckAndSetState),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: edgesStks[4], type: CardStackType.edge,onAccept: _winCheckAndSetState),
              CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: verticesStks[3], type: CardStackType.vertex,onAccept: _winCheckAndSetState),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accentLetterText(f, s, t, baseColor, accentColor, color1, color2){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(

            colors: [color1, color2]
        )
      ),
      child: Text.rich(
          TextSpan(
              text: f,
              style: TextStyle(
                  fontSize: 20,
                  color: baseColor
              ),
              children: [
                TextSpan(
                    text: s,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: accentColor
                    )
                ),
                TextSpan(
                    text: t
                )
              ]
          )
      ),
    );
  }

  Widget _buildThirdCol(width){
    return Padding(
      padding: EdgeInsets.only(left: cardWidth/2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _settingsButtonRow(),
          Spacer(),
          GestureDetector(
            onTap: (){
              if(discardStk.isEmpty) return;
              _showDiscardPile();
            },
              child: CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: discardStk, type: CardStackType.discard, fatherSetState: setState,onAccept: _winCheckAndSetState)),
          SizedBox(height: 20),
          Visibility(
            visible: true,
            child: SizedBox(
              width: cardWidth,
              child: KTextButton(
                "Summon Card",
                accentIndex: 7,
                enabled: canSummon && gamePoints.can(2) && discardStk.isNotEmpty,
                onPressed:(){
                  _showDiscardPile(summon: true);
                },
              ),
            ),
          ),
          SizedBox(height: 20),

          CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: allCards, type: CardStackType.deck, discardStk: discardStk, fatherSetState: setState,onAccept: _winCheckAndSetState),
          SizedBox(height: 40),
          SizedBox(
            width: cardWidth,
            child: KTextButton("Summon an Ace",
              enabled: gamePoints.can(2) && _allCardsHasAce(),
              accentIndex: 10,
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
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  List _dialogCardRow(List<PlayingCard> row, {bool summon = false}){

    double screenH = MediaQuery.of(context).size.height;
    double cardHeight = screenH/4;
    double cardWidth = cardHeight * 2/3;

    double space = _dialogWidth() - cardWidth;
    double spaceXcard = space / (row.length-1);
    double step = spaceXcard;

    if(spaceXcard >= cardWidth*7/9){
      step = cardWidth * 7/9;
    }

    double offset = 0;
    return row.map((e) {
        final w = GestureDetector(
          onTap: summon? (){
            setState(() {
              discardStk.remove(e);
              discardStk.add(e);
              gamePoints.dec(2);
              canSummon = false;
            });
            Navigator.pop(context);
          }: null,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: PlayingCardView(card: e),
          ),
        );

        final hoverWidget = HoverWidget(
            onHover: (p){},
            hoverChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  w,
                  SizedBox(height: 20),
                ]
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  w,
                  SizedBox(height: 10),
                ]
            ));


        final transformed = Transform.translate(
          offset: Offset(offset, 0),
          child: hoverWidget,
        );
        // increment offset
        offset += step;
        return transformed;
    }).toList();

  }

  Widget _dialogCardColumn({bool summon = false}){

    final stk = discardStk;

    int start = 0;
    int end = min(stk.length, 10);

    final firstRow = stk.sublist(start, end);
    start = end;
    end = min(stk.length, 20);
    final secondRow = stk.sublist(start, end);
    start = end;
    end = stk.length;
    final thirdRow = stk.sublist(start, end);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          children: [
            Container(),
            ..._dialogCardRow(firstRow, summon: summon)
          ],
        ),
        Stack(
          children: [
            Container(),
            ..._dialogCardRow(secondRow, summon: summon)
          ],
        ),
        Stack(
          children: [
            Container(),
            ..._dialogCardRow(thirdRow, summon: summon)
          ],
        )
      ],
    );
  }

  double _dialogWidth() => MediaQuery.of(context).size.width * 2/3;
  double _dialogHeight() => (3 * cardHeight) + (cardHeight/2) + 60;

  void _showDiscardPile({bool summon = false}){

    final String title = summon? "Summon a card" : "Your Discard pile";
    showDialog(
      context: context,
      builder: (context){
        return Container(
          color: Color(0x7f3c0d1f),
          child: AlertDialog(
            backgroundColor: Color(0xff294543),
            surfaceTintColor: Color(0xff294543),
            content: Container(
              width: _dialogWidth(),
              height: _dialogHeight(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Text(title, style: TextStyle(
                          color: Color(0xffF9EFC2),
                          fontWeight: FontWeight.bold,
                          fontSize: 40),),

                      Spacer(),
                      KRoundButton("X", circular: true, onPressed: (){
                        Navigator.of(context).pop();
                      },),
                    ],
                  ),
                  Spacer(),
                  _dialogCardColumn(summon: summon),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _settingsButtonRow(){
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: cardWidth/1.5,
          ),
          KRoundButton("?", circular: true, onPressed: () {
            _showGameRules();
          },),
          SizedBox(
            width: 5,
          ),
          KIconButton(audioManager.audioEnabled? Icons.volume_up : Icons.volume_off, circular: true, fontSize: 38,
            onPressed: () {
            setState(() {
              audioManager.toggleAudio();
            });
          },),
          SizedBox(
            width: 5,
          ),
          KRoundButton("X", circular: true, onPressed: (){
            _showExitConfirmDialog();
          },),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    cardHeight = screenHeight/3;
    cardWidth = cardHeight * 2/3;
    final totalWidth = cardWidth * 8;


    if(screenWidth < totalWidth) {
      cardWidth = screenWidth/8;
      cardHeight = cardWidth * 3/2;
    }


    final first = 2.5*cardWidth;
    final second = 3*cardWidth;
    final third = 2.5*cardWidth;

    return GestureDetector(
      onTap: (){
        if(mainMusicOff){
          //mainMusic.play();
          mainMusicOff = false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Color(0xff171F22),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.red,
                    width: first,
                      height: screenHeight,
                      child: _buildFirstCol(first)
                  ),
                  Container(
                      // color: Colors.blue,
                      width: second,
                      height: screenHeight,
                      alignment: Alignment.center,
                      child: _buildBoard()),
                  Container(
                      // color: Colors.green,
                      width: third,
                      height: screenHeight,
                      child: _buildThirdCol(third)),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  bool _allCardsHasAce() {
    return allCards.any((element) => element.value == CardValue.ace);
  }
}
