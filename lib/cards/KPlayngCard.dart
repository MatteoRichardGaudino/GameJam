

import 'package:playing_cards/playing_cards.dart';

enum KSuit { eyes, hearts, mirrors, spectres }
enum KCardValue {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  ace,
}


class KPlayingCard {
  KSuit suit;
  KCardValue cardValue;

  KPlayingCard(this.suit, this.cardValue);
}


String suitToString(KSuit suit){
  switch(suit){
    case KSuit.eyes:
      return "eyes";
    case KSuit.hearts:
      return "hearts";
    case KSuit.mirrors:
      return "mirrors";
    case KSuit.spectres:
      return "spectres";
  }
}

String suitToStringUp(KSuit suit){
  String s = suitToString(suit);
  return s[0].toUpperCase() + s.substring(1);
}

String valueToString(KCardValue value){
  switch(value){
    case KCardValue.two:
      return "2";
    case KCardValue.three:
      return "3";
    case KCardValue.four:
      return "4";
    case KCardValue.five:
      return "5";
    case KCardValue.six:
      return "6";
    case KCardValue.seven:
      return "7";
    case KCardValue.eight:
      return "Page";
    case KCardValue.nine:
      return "Knight";
    case KCardValue.ten:
      return "King";
    case KCardValue.ace:
      return "Ace";
  }
}

String kCardToAsset(KPlayingCard card){
  return "assets/cards/" + suitToString(card.suit) + "/" + valueToString(card.cardValue) + " of " + suitToStringUp(card.suit) + ".png";
}
