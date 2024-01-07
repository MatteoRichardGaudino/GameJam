import 'package:flutter/material.dart';
import 'package:game_jam/cardStack.dart';
import 'package:playing_cards/playing_cards.dart';

class DemonHand extends StatelessWidget {
  const DemonHand(this.width, {super.key, required this.cardWidth, required this.cardHeight, required this.stk1, required this.stk2});

  final double width;
  final double cardWidth;
  final double cardHeight;

  final List<PlayingCard> stk1;
  final List<PlayingCard> stk2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -0,
            right: -25,
            child: Transform.rotate(
                angle: 0.5,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: stk1, type: CardStackType.demonHand),
                ))
        ),

        Positioned(
            top: -0,
            right: 140,
            child: Transform.rotate(
                angle: -0.4,
                child: CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: stk2, type: CardStackType.demonHand))
        ),
        IgnorePointer(
          ignoring: true,
          child: Image.asset("assets/mano-demone.png",
           width: width,
            //height: MediaQuery.of(context).size.height * 3/4,
          ),
        )
      ],
    );
  }
}
