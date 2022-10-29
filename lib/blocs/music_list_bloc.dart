

import 'dart:async';

import '../models/music_list.dart';
import '../networking/response.dart';
import '../repository/music_list_repository.dart';

class MusicListBloc{
   MusicListRepository? _musicListRepository;
   StreamController? _musicListController;


  StreamSink<dynamic> get musicListSink =>
    _musicListController!.sink;

     Stream<dynamic> get musicListStream =>
      _musicListController!.stream;

      MusicListBloc() {
        _musicListController = StreamController<dynamic>.broadcast();
         _musicListRepository = MusicListRepository();
          fetchMusicList();
      }


       fetchMusicList() async {
    musicListSink.add(Response.loading('Loading list.'));
    try {
      MusicList musicList = await _musicListRepository!.fetchMusicListData();
      musicListSink.add(Response.completed(musicList));
    } catch (e) {
      musicListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _musicListController!.close();
  }

}