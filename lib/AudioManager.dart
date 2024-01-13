import 'package:assets_audio_player/assets_audio_player.dart';

class AudioManager{

  bool audioEnabled = true;

  late AssetsAudioPlayer menu;
  bool isMenuPlaying = false;
  late AssetsAudioPlayer gameMusic;
  bool isGameMusicPlaying = false;


  AssetsAudioPlayer? currentAudioPlayer;


  AudioManager(){
    menu = AssetsAudioPlayer.newPlayer();
    menu.open(
      Audio("assets/music/divinazione_maintitle_compressed.mp3"),
      showNotification: false,
      autoStart: false,
      loopMode: LoopMode.playlist,
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
    );
    gameMusic.stop();
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