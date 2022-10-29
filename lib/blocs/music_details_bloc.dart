import 'dart:async';

import '../models/music_details.dart';
import '../networking/response.dart';
import '../repository/music_details_repository.dart';

class MusicDetailsBloc {
  MusicDetailsRepository? _musicDetailsRepository;
  StreamController? _musicDetailsController;
  int? trackId;
  StreamSink<dynamic> get musicDetailsSink =>
      _musicDetailsController!.sink;

  Stream<dynamic> get musicDetailsStream =>
      _musicDetailsController!.stream;

  MusicDetailsBloc({required this.trackId}) {
    _musicDetailsController =
        StreamController<dynamic>.broadcast();
    _musicDetailsRepository = MusicDetailsRepository(trackId: trackId);
    // fetchMusicDetails();
  }
  fetchMusicDetails() async {
    musicDetailsSink.add(Response.loading('Loading details.. '));
    try {
      MusicDetails musicDetails =
          await _musicDetailsRepository!.fetchMusicDetailsData();
      musicDetailsSink.add(Response.completed(musicDetails));
    } catch (e) {
      musicDetailsSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _musicDetailsController!.close();
  }
}
