import 'package:assets_audio_player/assets_audio_player.dart';

class AudioManager{

  bool audioEnabled = true;

  late AssetsAudioPlayer menu;
  bool isMenuPlaying = false;
  late AssetsAudioPlayer gameMusic;
  bool isGameMusicPlaying = false;



  // ---------------- Effects ----------------

  /*
  * - assets/effects/exit_game.wav
    - assets/effects/game_over_completo.wav
    - assets/effects/options_hover.wav
    - assets/effects/options_selection.wav
    - assets/effects/rules.wav
    - assets/effects/suono_accedi_pila_scarti.wav
    - assets/effects/suono_candele_che_si_accendono.wav
    - assets/effects/suono_evoca_Asso.wav
    - assets/effects/suono_evoca_carta.wav
    - assets/effects/suono_mettere_carta_nella_mano_del_demone.wav
    - assets/effects/suono_metti_carta_in_un_posto_qualsiasi.wav
    - assets/effects/suono_pesca_dal_mazzo_di_pesca.wav
    - assets/effects/suono_scegli_carta_discard_pile.wav
    - assets/effects/suono_vittoria_completo.wav
  * */

  late final AssetsAudioPlayer _exitGame; // ok
  late final AssetsAudioPlayer _gameOver; //ok
  late final AssetsAudioPlayer _optionsHover; // ok
  late final AssetsAudioPlayer _optionsSelection;
  late final AssetsAudioPlayer _rules; // ok
  late final AssetsAudioPlayer _suonoAccediPilaScarti; // ok
  late final AssetsAudioPlayer _suonoCandeleCheSiAccendono; // ok
  late final AssetsAudioPlayer _suonoEvocaAsso; // ok
  late final AssetsAudioPlayer _suonoEvocaCarta; // ok
  late final AssetsAudioPlayer _suonoMettereCartaNellaManoDelDemone; // ok
  late final AssetsAudioPlayer _suonoMettiCartaInUnPostoQualsiasi; // ok
  late final AssetsAudioPlayer _suonoPescaDalMazzoDiPesca; // ok
  // late final AssetsAudioPlayer _suonoScegliCartaDiscardPile; // no
  late final AssetsAudioPlayer _suonoVittoriaCompleto; // ok

  // ---------------- end Effects ----------------


  AssetsAudioPlayer? currentAudioPlayer;

  AssetsAudioPlayer newAudio(String path){
    return AssetsAudioPlayer.newPlayer()..open(
      Audio(path),
      showNotification: false,
      autoStart: false,
    );
  }


  AudioManager(){
    menu = AssetsAudioPlayer.newPlayer();
    menu.open(
      Audio("assets/music/divinazione_maintitle_compressed.mp3"),
      showNotification: false,
      autoStart: false,
      loopMode: LoopMode.playlist,
      volume: 0.4,
    );
    try{
      menu.play();
    } catch(e){}
    currentAudioPlayer = menu;

    gameMusic = AssetsAudioPlayer.newPlayer();
    gameMusic.open(
      Audio("assets/music/divinazione_game_compressed.mp3"),
      showNotification: false,
      autoStart: false,
      loopMode: LoopMode.playlist,
      volume: 0.4,
    );
    gameMusic.stop();


    loadEffects();
  }

  Future loadEffects() async{

      _optionsHover = AssetsAudioPlayer.newPlayer()..open(
        Audio("assets/effects/options_hover.wav"),
        showNotification: false,
        autoStart: false,
        volume: 0.7
    );
    _optionsSelection = AssetsAudioPlayer.newPlayer()..open(
        Audio("assets/effects/options_selection.wav"),
        showNotification: false,
        autoStart: false,
        volume: 0.7
    );
    _exitGame = newAudio("assets/effects/exit_game.wav");
    _gameOver = newAudio("assets/effects/game_over_completo.wav");
    // _optionsSelection = newAudio("assets/effects/options_selection.wav");
    _rules = newAudio("assets/effects/rules.wav");
    _suonoAccediPilaScarti = newAudio("assets/effects/suono_accedi_pila_scarti.wav");
    _suonoCandeleCheSiAccendono = newAudio("assets/effects/suono_candele_che_si_accendono.wav");
    _suonoEvocaAsso = newAudio("assets/effects/suono_evoca_Asso.wav");
    _suonoEvocaCarta = newAudio("assets/effects/suono_evoca_carta.wav");
    _suonoMettereCartaNellaManoDelDemone = newAudio("assets/effects/suono_mettere_carta_nella_mano_del_demone.wav");
    _suonoMettiCartaInUnPostoQualsiasi = newAudio("assets/effects/suono_metti_carta_in_un_posto_qualsiasi.wav");
    _suonoPescaDalMazzoDiPesca = newAudio("assets/effects/suono_pesca_dal_mazzo_di_pesca.wav");
    // _suonoScegliCartaDiscardPile = newAudio("assets/effects/suono_scegli_carta_discard_pile.wav");
    _suonoVittoriaCompleto = newAudio("assets/effects/suono_vittoria_completo.wav");


  }

  void playExitGame() { if(audioEnabled) _exitGame.play(); }
  void playGameOver() async {
    if(audioEnabled){
      await stopGameMusic();
      _gameOver.play();
    }
  }
  void playOptionsHover() { if(audioEnabled) _optionsHover.play(); }
  void playOptionsSelection() { if(audioEnabled) _optionsSelection.play(); }
  void playRules() { if(audioEnabled) _rules.play(); }
  void playSuonoAccediPilaScarti() { if(audioEnabled) _suonoAccediPilaScarti.play(); }
  void playSuonoCandeleCheSiAccendono() { if(audioEnabled) _suonoCandeleCheSiAccendono.play(); }
  void playSuonoEvocaAsso() { if(audioEnabled) _suonoEvocaAsso.play(); }
  void playSuonoEvocaCarta() { if(audioEnabled) _suonoEvocaCarta.play(); }
  void playSuonoMettereCartaNellaManoDelDemone() { if(audioEnabled) _suonoMettereCartaNellaManoDelDemone.play(); }
  void playSuonoMettiCartaInUnPostoQualsiasi() { if(audioEnabled) _suonoMettiCartaInUnPostoQualsiasi.play(); }
  void playSuonoPescaDalMazzoDiPesca() { if(audioEnabled) _suonoPescaDalMazzoDiPesca.play(); }
  // void playSuonoSc/egliCartaDiscardPile() { if(audioEnabled) _suonoScegliCartaDiscardPile.play(); }
  void playSuonoVittoriaCompleto() async {
    if(audioEnabled) {
      await stopGameMusic();
      _suonoVittoriaCompleto.play();
    }
  }

  Future playMenu() async {
    currentAudioPlayer = menu;

    if(!isMenuPlaying && audioEnabled){
      await menu.seek(Duration.zero);
      await menu.play();
      isMenuPlaying = true;
    }
  }

  Future stopMenu() async {
    if(isMenuPlaying && audioEnabled){
      await menu.stop();
      isMenuPlaying = false;
    }
  }

  Future playGameMusic() async {
    currentAudioPlayer = gameMusic;

    if(!isGameMusicPlaying && audioEnabled){
      await gameMusic.seek(Duration.zero);
      await gameMusic.play();
      isGameMusicPlaying = true;
    }
  }

  Future stopGameMusic() async {
    if(isGameMusicPlaying && audioEnabled){
      await gameMusic.stop();
      isGameMusicPlaying = false;
    }
  }


  Future toggleAudio() async {
    if(audioEnabled){
      await currentAudioPlayer!.stop();
      audioEnabled = false;
    } else {
      await currentAudioPlayer!.play();
      audioEnabled = true;
    }
  }
}

final AudioManager audioManager = AudioManager();