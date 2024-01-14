import 'package:flutter/material.dart';
import 'package:game_jam/cardStack.dart';
import 'package:game_jam/cards/KPlayngCard.dart';

class DemonHand extends StatelessWidget {
  DemonHand(this.width, {super.key, required this.cardWidth, required this.cardHeight, required this.stk1, required this.stk2, required this.onAccept});

  final double width;
  final double cardWidth;
  final double cardHeight;

  final List<KPlayingCard> stk1;
  final List<KPlayingCard> stk2;

  dynamic Function() onAccept;

  @override
  Widget build(BuildContext context) {

    // original 589x840
    // aspect ratio 0.7 w/h

    double imageHeight = cardHeight*2;
    double imageWidth = imageHeight*0.7;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            top: imageHeight/40,
            left: imageWidth/10,
            child: Transform.rotate(
                angle: -0.3,
                child: CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: stk2, type: CardStackType.demonHand, onAccept: onAccept))
        ),

        Positioned(
            top: -imageHeight/30,
            right: 0 + imageWidth/10,
            child: Transform.rotate(
                angle: 0.4,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: CardStack(cardWidth: cardWidth, cardHeight: cardHeight, stk: stk1, type: CardStackType.demonHand, onAccept: onAccept),
                ))
        ),
        IgnorePointer(
          ignoring: true,
          child: Transform.translate(
            offset: Offset(-imageWidth/8 - imageWidth/10, imageHeight/6),
            child: Image.asset("assets/mano-demone.png",
              width: imageWidth,
              height: imageHeight,
            ),
          ),
        )
      ],
    );
  }
}
