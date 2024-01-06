class Points{
  int points = 0;

  Function() onChange = (){};


  void inc(){
    if(points == 3) return;
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
}

Points gamePoints = Points();