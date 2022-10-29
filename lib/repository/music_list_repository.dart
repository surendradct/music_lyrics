
import '../constants.dart';
import '../models/music_list.dart';
import '../networking/api_provider.dart';

class MusicListRepository {

  final ApiProvider _provider = ApiProvider();  
  Future<MusicList> fetchMusicListData() async {
    final response = await _provider.get("chart.tracks.get?apikey=$apikey");
    print(MusicList.fromJson(response));
    return MusicList.fromJson(response);
  }
}