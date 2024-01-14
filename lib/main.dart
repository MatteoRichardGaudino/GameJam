// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:game_jam/AudioManager.dart';
import 'package:game_jam/buttons/KIconButton.dart';
import 'package:game_jam/cards/KPlayngCard.dart';
import 'package:game_jam/cards/KPlayngCardView.dart';
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

enum Screens{
  intro,
  title,
  game
}

class MainTitle extends StatefulWidget {
  const MainTitle({super.key});

  @override
  State<MainTitle> createState() => _MainTitleState();
}

class _MainTitleState extends State<MainTitle> {

  Screens currentScreen = Screens.intro;

  Widget _buildTitle(){
    return Scaffold(
      backgroundColor: Color(0xff171F22),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff171F22),
        child: FadeIn(
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
                    currentScreen = Screens.game;
                    audioManager.stopMenu().then((value) => audioManager.playGameMusic());
                    audioManager.playOptionsSelection();
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
          currentScreen = Screens.title;
          audioManager.playExitGame();
          audioManager.stopGameMusic().then((value) => audioManager.playMenu());
        });
      }),
    );
  }

  Widget _buildIntro(){
    return Scaffold(
      backgroundColor: Color(0xff171F22),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff191f22),
        child: GestureDetector(
          onTap: (){
            setState(() {
              currentScreen = Screens.title;
              audioManager.playMenu();
            });
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FadeIn(
                duration: Duration(seconds: 5),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xff8bb48d),
                      fontWeight: FontWeight.bold
                    ),
                    children: [
                      TextSpan(text: "\"Oh "),
                      TextSpan(
                        text: "Kaalub",
                        style: TextStyle(color: Color(0xffcc867d),)
                      ),
                      TextSpan(text: "! Oracle of Obsessions and Mistress of the Unknown!\n" +
                          "For years I've tried relentlessly to build a "),
                      TextSpan(
                          text: "connection ",
                          style: TextStyle(color: Color(0xffcc867d),)
                      ),
                      TextSpan(text: "between our words, and ask you to concede me your demonic power!\n" +
                          "But now, with my new summoning ritual I will finally be able to connect with you and "),
                      TextSpan(
                          text: "see the future ",
                          style: TextStyle(color: Color(0xffcc867d),)
                      ),
                      TextSpan(text: "!\""),

                      TextSpan(
                        text: "\n\n\nClick on the screen to continue",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffe0ba8b),
                          fontWeight: FontWeight.normal
                        )
                      )
                    ],
                ),
                textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff171F22),
        child: switch(currentScreen){
          Screens.title => _buildTitle(),
          Screens.game => _buildMainGame(),
          Screens.intro => _buildIntro(),
        },
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

  final allCards = <KPlayingCard>[];
  final initialCards = <KPlayingCard>[];

  final edgesStks = <List<KPlayingCard>>[];
  final verticesStks = <List<KPlayingCard>>[];
  final demonHand1Stk = <KPlayingCard>[];
  final demonHand2Stk = <KPlayingCard>[];

  final discardStk = <KPlayingCard>[];

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

    allCards.addAll([
      KPlayingCard(KSuit.eyes, KCardValue.ace),
      KPlayingCard(KSuit.eyes, KCardValue.two),
      KPlayingCard(KSuit.eyes, KCardValue.three),
      KPlayingCard(KSuit.eyes, KCardValue.four),
      KPlayingCard(KSuit.eyes, KCardValue.five),
      KPlayingCard(KSuit.eyes, KCardValue.six),
      KPlayingCard(KSuit.eyes, KCardValue.seven),
      KPlayingCard(KSuit.eyes, KCardValue.eight),
      KPlayingCard(KSuit.eyes, KCardValue.nine),
      KPlayingCard(KSuit.eyes, KCardValue.ten),

      KPlayingCard(KSuit.hearts, KCardValue.two),
      KPlayingCard(KSuit.hearts, KCardValue.three),
      KPlayingCard(KSuit.hearts, KCardValue.four),
      KPlayingCard(KSuit.hearts, KCardValue.five),
      KPlayingCard(KSuit.hearts, KCardValue.six),
      KPlayingCard(KSuit.hearts, KCardValue.seven),
      KPlayingCard(KSuit.hearts, KCardValue.eight),
      KPlayingCard(KSuit.hearts, KCardValue.nine),
      KPlayingCard(KSuit.hearts, KCardValue.ten),

      KPlayingCard(KSuit.mirrors, KCardValue.two),
      KPlayingCard(KSuit.mirrors, KCardValue.three),
      KPlayingCard(KSuit.mirrors, KCardValue.four),
      KPlayingCard(KSuit.mirrors, KCardValue.five),
      KPlayingCard(KSuit.mirrors, KCardValue.six),
      KPlayingCard(KSuit.mirrors, KCardValue.seven),
      KPlayingCard(KSuit.mirrors, KCardValue.eight),
      KPlayingCard(KSuit.mirrors, KCardValue.nine),
      KPlayingCard(KSuit.mirrors, KCardValue.ten),

      KPlayingCard(KSuit.spectres, KCardValue.two),
      KPlayingCard(KSuit.spectres, KCardValue.three),
      KPlayingCard(KSuit.spectres, KCardValue.four),
      KPlayingCard(KSuit.spectres, KCardValue.five),
      KPlayingCard(KSuit.spectres, KCardValue.six),
      KPlayingCard(KSuit.spectres, KCardValue.seven),
      KPlayingCard(KSuit.spectres, KCardValue.eight),
      KPlayingCard(KSuit.spectres, KCardValue.nine),
      KPlayingCard(KSuit.spectres, KCardValue.ten),

    ]);
    verticesStks.addAll([
      [],
      [],
      [],
      [],
    ]);

    allCards.shuffle();

    // if one of the first 4 cards is an ace replace it with the first non-ace card
    for(int i = 0; i < 5; i++){
      if(allCards[i].value == KCardValue.ace){
        for(int j = 5; j < allCards.length; j++){
          if(allCards[j].value != KCardValue.ace){
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
      // [KPlayingCard(Suit.clubs, KCardValue.four)],
      // [KPlayingCard(Suit.clubs, KCardValue.two)],
      // [KPlayingCard(Suit.clubs, KCardValue.three)],
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
    if(verticesStks.every((element) => element.isNotEmpty && element.last.value == KCardValue.ten)){
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
      if(verticesStks.any((element) => (element.isEmpty && card.value == KCardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
    }
    // same thing for demon hand
    if(demonHand1Stk.isNotEmpty){
      final card = demonHand1Stk.last;
      if(edgesStks.any((element) => element.isEmpty || descRule(element.last, card))) return GameState.playing;
      if(verticesStks.any((element) => (element.isEmpty && card.value == KCardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
    }
    if(demonHand2Stk.isNotEmpty){
      final card = demonHand2Stk.last;
      if(edgesStks.any((element) => element.isEmpty || descRule(element.last, card))) return GameState.playing;
      if(verticesStks.any((element) => (element.isEmpty && card.value == KCardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
    }
    // if can move a card from the edges to the vertices return playing
    for(int i = 0; i < edgesStks.length; i++){
      final stk = edgesStks[i];
      if(stk.isNotEmpty) {
        final card = edgesStks[i].last;
        if(verticesStks.any((element) => (element.isEmpty && card.value == KCardValue.ace) || (element.isNotEmpty && crescentRule(element.last, card)))) return GameState.playing;
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
      audioManager.playSuonoVittoriaCompleto();
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
        audioManager.playOptionsSelection();
      });
    });
  }

  void _showGameOverDialog(){
    showDialog(context: context, builder: (context){
      audioManager.playGameOver();
      return GameOverDialog(() => {
        Navigator.pop(context),
        widget.onBack?.call()
      });
    });
  }

  void _showGameRules(){
    showDialog(context: context, builder: (context){
      audioManager.playRules();
      return GameRulesDialog();
    });
  }

  // build three dots in a row
  Widget _buildPowerSlots(width){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        PowerSlot(gamePoints.can(1), width: width/3,),
        PowerSlot(gamePoints.can(2), width: width/3, offset: -width/3 * 2/4,),
        PowerSlot(gamePoints.can(3), width: width/3, offset: (-width/3 * 4/4)),
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
          Spacer(flex: 1,),
          GestureDetector(
            onTap: (){
              if(discardStk.isEmpty) return;
              _showDiscardPile();
            },
              child: CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: discardStk, type: CardStackType.discard, fatherSetState: setState,onAccept: _winCheckAndSetState)),
          SizedBox(height: 5),
          SizedBox(
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
          SizedBox(height: 20),

          CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: allCards, type: CardStackType.deck, discardStk: discardStk, fatherSetState: setState,onAccept: _winCheckAndSetState),
          SizedBox(height: 5),
          SizedBox(
            width: cardWidth,
            child: KTextButton("Summon an Ace",
              enabled: gamePoints.can(2) && _allCardsHasAce(),
              accentIndex: 10,
              onPressed: (){
                if(!gamePoints.can(2)) return;
                final index = allCards.indexWhere((element) => element.value == KCardValue.ace);
                if(index == -1) return;
                final card = allCards.removeAt(index);
                print("Summoning an ace. index = $index, points = ${gamePoints.points}");

                for(int i = 0; i < verticesStks.length; i++){
                  if(verticesStks[i].isEmpty){
                  verticesStks[i].add(card);
                  gamePoints.dec(2);
                  audioManager.playSuonoEvocaAsso();
                  break;
                }
                }
              },
            ),
          ),
          Spacer(flex: 2,)
        ],
      ),
    );
  }

  List _dialogCardRow(List<KPlayingCard> row, {bool summon = false}){

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
            audioManager.playSuonoEvocaCarta();
            Navigator.pop(context);
          }: null,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: KPlayingCardView(e, cardWidth, cardHeight),
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
    audioManager.playSuonoAccediPilaScarti();

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
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: cardWidth*0.5,
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

    // cardHeight/cardwidth =  175/100


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    cardHeight = screenHeight/3;
    cardWidth = cardHeight * 100/175;
    final totalWidth = cardWidth * 8;


    if(screenWidth < totalWidth) {
      cardWidth = screenWidth/8;
      cardHeight = cardWidth * 175/100;
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
    return allCards.any((element) => element.value == KCardValue.ace);
  }
}
