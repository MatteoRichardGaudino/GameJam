import 'package:flutter/material.dart';
import 'package:game_jam/cards/KPlayngCard.dart';

class KPlayingCardView extends StatelessWidget {
  const KPlayingCardView(this.card, this.width, this.height, {super.key, this.showBack = false});


  final KPlayingCard card;
  final double width;
  final double height;
  final bool showBack;

  Widget _card(){
    if(showBack) {
      return Image.asset(
        "assets/carta-retro.png",
        width: width,
        height: height,
        fit: BoxFit.fill,
      );

    } else {
      return Image.asset(
        kCardToAsset(card),
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xff8bb48d), width: 2)
      ),
      margin: EdgeInsets.all(8),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: _card()),
    );
  }
}
