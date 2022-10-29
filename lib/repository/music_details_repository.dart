

import '../constants.dart';
import '../models/music_details.dart';
import '../networking/api_provider.dart';

class MusicDetailsRepository {
   int? trackId;
  MusicDetailsRepository({required this.trackId});
  final ApiProvider _provider = ApiProvider();
  Future<MusicDetails> fetchMusicDetailsData() async {
    final response =
        await _provider.get("track.get?track_id=$trackId&apikey=$apikey");
    return MusicDetails.fromJson(response, trackId);
  }
}