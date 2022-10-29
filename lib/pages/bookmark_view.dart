import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_lyrics/pages/music_list_view.dart';
// ignore: library_prefixes
import 'package:music_lyrics/models/music_list.dart' as ListTrack;



class BookmarkView extends StatefulWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {

List<String>? trackIdList;
  List<String>? trackNameList;
  List<String>? trackAlbumList;
  List<String>? trackArtistList;
  @override
  void initState() {
    super.initState();
  }

  void sharedPref() async {
    final perfs = await SharedPreferences.getInstance();
    setState(() {
      trackIdList = perfs.getStringList('bookmarkList');
      trackNameList = perfs.getStringList('nameList');
      trackAlbumList = perfs.getStringList('albumList');
      trackAlbumList = perfs.getStringList('artistList');
    });
  }

  @override
  Widget build(BuildContext context) {
    sharedPref();
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 243, 3, 3),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,

            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // ignore: prefer_is_empty
      body: (trackIdList == null || trackIdList?.length == 0)
          ? const Center(
              child: Text(
                'No bookmarks added',
                style: TextStyle(color: Colors.grey, fontSize: 20.0),
              ),
            )
          : listViewBuilder(),
          
    );

  }

  listViewBuilder() {
    return ListView.builder(
        itemBuilder: (context, index) {
          ListTrack.Track track = ListTrack.Track( trackName: '', artistName: '', albumName: '');
          track.trackId = int.parse(trackIdList![index]);
          track.trackName = trackNameList![index];
          track.albumName = trackAlbumList![index];
          track.artistName = trackAlbumList![index];
          return TrackTile(
            track: track,
          );
        },
        itemCount: trackIdList!.length);
  }
}
