import 'package:game_jam/AudioManager.dart';
import 'package:playing_cards/playing_cards.dart';

class Points{
  int points = 0;

  final List<(PlayingCard, PlayingCard)> _pairs = [];


  void addPair(PlayingCard a, PlayingCard b){
    _pairs.add((a, b));
  }

  bool hasPair(PlayingCard a, PlayingCard b){
    for(final i in _pairs){
      if(i.$1 == a && i.$2 == b) return true;
    }
    return false;
  }

  Function() onChange = (){};


  void inc(){
    if(points == 3) return;
    audioManager.playSuonoCandeleCheSiAccendono();
    points++;
    onChange();
  }

  bool can(int x){
    return points >= x;
  }

  void dec(int x){
    if(points < x) throw Exception("Not enough points");
    points -= x;
    onChange();
  }

  void reset(){
    points = 0; // TODO
    _pairs.clear();
    onChange = (){};
  }
}

Points gamePoints = Points();