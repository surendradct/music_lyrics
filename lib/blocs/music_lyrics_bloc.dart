


// ignore_for_file: avoid_print

import 'dart:async';



import '../models/music_lyrics.dart';
import '../networking/response.dart';
import '../repository/music_lyrics_repository.dart';

class MusicLyricsBloc {
  MusicLyricsRepository? _musicLyricsRepository;
  StreamController? _musicLyricsController;
  int? trackId;
  
  StreamSink<dynamic>get musicLyricsSink =>
      _musicLyricsController!.sink;

  Stream<dynamic> get musicLyricsStream =>
      _musicLyricsController!.stream;

  MusicLyricsBloc({trackId}) {
    _musicLyricsController =
        StreamController<dynamic>.broadcast();
    _musicLyricsRepository = MusicLyricsRepository(trackId: trackId);
    fetchMusicLyrics();
  }
  fetchMusicLyrics() async {
    musicLyricsSink.add(Response.loading('Loading lyrics'));
    try {
      MusicLyrics musicLyrics =
          await _musicLyricsRepository!.fetchMusicDetailsData();
      musicLyricsSink.add(Response.completed(musicLyrics));
    } catch (e) {
      print(e);
    }
  }

  dispose() {
    _musicLyricsController!.close();
    
    
  }
}
