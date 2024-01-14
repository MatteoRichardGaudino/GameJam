import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:game_jam/AudioManager.dart';
import 'package:game_jam/cards/KPlayngCard.dart';
import 'package:game_jam/cards/KPlayngCardView.dart';
import 'package:game_jam/points.dart';

enum CardStackType {
  vertex,
  edge,
  discard,
  deck,
  demonHand,
}

class CardStack extends StatefulWidget {
  CardStack({super.key, required this.cardWidth, required this.cardHeight, required this.stk, required this.type, this.discardStk, this.fatherSetState, required this.onAccept});
  double cardWidth;
  double cardHeight;
  List<KPlayingCard> stk;
  List<KPlayingCard>? discardStk;
  CardStackType type;
  void Function(void Function())? fatherSetState;

  dynamic Function() onAccept;

  KPlayingCard top(){
    return stk[stk.length - 1];
  }

  bool hasTop(){
    return stk.isNotEmpty;
  }

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {

  bool accepted = false;

  bool canAccept(CardStack other){
    if(widget.type == CardStackType.deck) return false; // deck can't accept anything
    else if(widget.type == CardStackType.discard){ // discard can only accept deck
      return other.type == CardStackType.deck;
    }

    else if(widget.type == CardStackType.vertex){
      if(widget.stk.isEmpty){
        return other.top().value == KCardValue.ace; // empty vertex can only accept aces
      } else {
        return crescentRule(widget.top(), other.top());
      }
    }

    else if(widget.type == CardStackType.edge){
      if(other.top().value == KCardValue.ace) return false; // edge can't accept aces
      if(widget.stk.isEmpty){
        return true; // empty edge can accept anything but other edges
      } else {
        return descRule(widget.top(), other.top());
      }
    }

    else if(widget.type == CardStackType.demonHand){
      if(other.top().value == KCardValue.ace) return false; // demon hand can't accept aces
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
        data.accepted = true;

        dynamic ss = setState;
        if(widget.type == CardStackType.discard){
          ss = widget.fatherSetState!;
        }

        ss(() {
          final card = data.widget.stk.removeLast();

          if(widget.type == CardStackType.edge && widget.stk.isNotEmpty){
            if(!gamePoints.hasPair(card, widget.top())){
              gamePoints.inc();
              gamePoints.addPair(card, widget.top());
            }
          }
          if(widget.type == CardStackType.demonHand){
            gamePoints.dec(1);
          }

          widget.stk.add(card);
          widget.onAccept();
          playAudioOnAccept();
        });
      },
    );
  }

  void playAudioOnAccept() async {
    if(widget.type == CardStackType.demonHand){
      audioManager.playSuonoMettereCartaNellaManoDelDemone();
    } else {
      audioManager.playSuonoMettiCartaInUnPostoQualsiasi();
    }
  }

  Widget _buildCardPlaceholder(){
    int internalPadding = 30;
    return Container(
      height: widget.cardHeight,
      width: widget.cardWidth,
      child: Center(
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(20),
          color: Color(0xff294644),
          dashPattern: [10, 15],
          strokeCap: StrokeCap.round,
          strokeWidth: 4,
          child: Container(
            height: widget.cardHeight-internalPadding,
            width: widget.cardWidth-internalPadding,
          ),
        ),
      ),
    );
  }

  bool cancelled = false;
  Widget _buildCardStack(){
    final first = widget.stk[widget.stk.length - 1];
    final second = (widget.stk.length == 1)? null : widget.stk[widget.stk.length - 2];

    if(widget.type == CardStackType.vertex){
      return cardContainer(first);
    } else {
      return Draggable(
        data: this,
        childWhenDragging: (second == null)? _buildCardPlaceholder() : cardContainer(second),
        child: cardContainer(first),
        feedback: cardContainer(first, forceShow: true),
        onDragCompleted: (){
          if(widget.type == CardStackType.deck && !accepted){
            widget.fatherSetState!((){
              final card = widget.stk.removeLast();
              widget.discardStk!.add(card);
              widget.onAccept();
              playAudioOnAccept();
            });
          }
          accepted = false;
          setState(() {

          });
        },
        onDragStarted: (){
          if(widget.type == CardStackType.deck){
            audioManager.playSuonoPescaDalMazzoDiPesca();
          }
        },
        onDraggableCanceled: (v, o){
          if(widget.type == CardStackType.deck){
            accepted = false;
            widget.fatherSetState!((){
              final card = widget.stk.removeLast();
              widget.discardStk!.add(card);
              widget.onAccept();
              playAudioOnAccept();
            });
          }
        },
      );
    }
  }

  Widget cardContainer(KPlayingCard card, {bool forceShow = false}){
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      child: KPlayingCardView(
          card,
          widget.cardWidth,
          widget.cardHeight,
          showBack: !forceShow && widget.type == CardStackType.deck,
      ),
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


bool crescentRule(KPlayingCard top, KPlayingCard newCard){
  if(newCard.suit != top.suit) return false;
  int topV = top.value.index;
  int newCardV = newCard.value.index;
  if(top.value == KCardValue.ace) topV = -1;
  if(newCard.value == KCardValue.ace) newCardV = -1;

  return newCardV == topV + 1;
}

bool descRule(KPlayingCard top, KPlayingCard newCard){
  if(newCard.suit != top.suit) return false;
  int topV = top.value.index;
  int newCardV = newCard.value.index;
  if(top.value == KCardValue.ace) topV = -1;
  if(newCard.value == KCardValue.ace) newCardV = -1;

  return newCardV + 1 == topV;
}