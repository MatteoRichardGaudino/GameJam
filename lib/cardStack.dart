import 'package:flutter/material.dart';
import 'package:game_jam/points.dart';
import 'package:playing_cards/playing_cards.dart';

enum CardStackType {
  vertex,
  edge,
  discard,
  deck,
  demonHand,
}

class CardStack extends StatefulWidget {
  CardStack({super.key, required this.cardWidth, required this.cardHeight, required this.stk, required this.type});
  double cardWidth;
  double cardHeight;
  List<PlayingCard> stk = [];
  CardStackType type;

  _CardStackState? state;

  PlayingCard top(){
    return stk[stk.length - 1];
  }

  bool hasTop(){
    return stk.isNotEmpty;
  }

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {


  bool canAccept(CardStack other){
    if(widget.type == CardStackType.deck) return false; // deck can't accept anything
    else if(widget.type == CardStackType.discard){ // discard can only accept deck
      return other.type == CardStackType.deck;
    }

    else if(widget.type == CardStackType.vertex){
      if(widget.stk.isEmpty){
        return other.top().value == CardValue.ace; // empty vertex can only accept aces
      } else {
        return crescentRule(widget.top(), other.top());
      }
    }

    else if(widget.type == CardStackType.edge){
      if(widget.stk.isEmpty){
        return true; // empty edge can accept anything
      } else {
        return descRule(widget.top(), other.top());
      }
    }

    else if(widget.type == CardStackType.demonHand){
      return gamePoints.can(1) && widget.stk.isEmpty;
    }

    return true;
  }

  Widget _buildCardTarget(Widget child){
    return DragTarget<_CardStackState>(
      builder: (context, candidateData, rejectedData){
        return child;
      },

      onAccept: (data){
        if(!canAccept(data.widget)) return;

        setState(() {
          final card = data.widget.stk.removeLast();
          widget.stk.add(card);

          if(widget.type == CardStackType.edge && widget.stk.isNotEmpty){
            gamePoints.inc();
          }
          if(widget.type == CardStackType.demonHand){
            gamePoints.dec(1);
          }
        });
      },
    );
  }

  Widget _buildCardPlaceholder(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey, width: 5),
      ),
      height: widget.cardHeight,
      width: widget.cardWidth,
    );
  }

  Widget _buildCardStack(){
    final first = widget.stk[widget.stk.length - 1];
    final second = (widget.stk.length == 1)? null : widget.stk[widget.stk.length - 2];

    return Draggable(
        data: this,
        childWhenDragging: (second == null)? _buildCardPlaceholder() : cardContainer(second),
        child: cardContainer(first),
        feedback: cardContainer(first),
        onDragCompleted: (){
          setState(() {});
        },
    );
  }

  Widget cardContainer(PlayingCard card){
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      child: PlayingCardView(card: card, showBack: widget.type == CardStackType.deck),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.stk.isEmpty) {
      return _buildCardTarget(_buildCardPlaceholder());
    } else {
      return _buildCardTarget(_buildCardStack());
    }
  }
}


bool crescentRule(PlayingCard top, PlayingCard newCard){
  if(newCard.suit != top.suit) return false;
  int topV = top.value.index;
  int newCardV = newCard.value.index;
  if(top.value == CardValue.ace) topV = -1;
  if(newCard.value == CardValue.ace) newCardV = -1;

  return newCardV == topV + 1;
}

bool descRule(PlayingCard top, PlayingCard newCard){
  if(newCard.suit != top.suit) return false;
  int topV = top.value.index;
  int newCardV = newCard.value.index;
  if(top.value == CardValue.ace) topV = -1;
  if(newCard.value == CardValue.ace) newCardV = -1;

  return newCardV + 1 == topV;
}