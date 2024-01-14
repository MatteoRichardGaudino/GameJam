import 'package:flutter/material.dart';
import 'package:game_jam/cards/KPlayngCard.dart';

class KPlayngCardView extends StatelessWidget {
  const KPlayngCardView(this.card, this.width, this.height, {super.key});


  final KPlayingCard card;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        kCardToAsset(card),
        width: width,
        height: height,
    );
  }
}
