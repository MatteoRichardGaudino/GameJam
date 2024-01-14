import 'package:game_jam/AudioManager.dart';
import 'package:game_jam/cards/KPlayngCard.dart';

class Points{
  int points = 0;

  final List<(KPlayingCard, KPlayingCard)> _pairs = [];


  void addPair(KPlayingCard a, KPlayingCard b){
    _pairs.add((a, b));
  }

  bool hasPair(KPlayingCard a, KPlayingCard b){
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
    points = 0;
    _pairs.clear();
    onChange = (){};
  }
}

Points gamePoints = Points();