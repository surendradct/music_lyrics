import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_lyrics/blocs/connectivity_bloc.dart';
import 'package:music_lyrics/blocs/music_list_bloc.dart';
import 'package:music_lyrics/models/music_list.dart';
import 'package:music_lyrics/networking/response.dart';
import 'package:music_lyrics/pages/bookmark_view.dart';

import 'music_lyrics_view.dart';

class OpenMusicList extends StatefulWidget {
  const OpenMusicList({Key? key}) : super(key: key);

  @override
  State<OpenMusicList> createState() => _OpenMusicListState();
}

class _OpenMusicListState extends State<OpenMusicList> {
  final ConnectivityBloc _netBloc = ConnectivityBloc();
  final MusicListBloc _bloc = MusicListBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        title: const Text(
          "Music Lyrics",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookmarkView(),
                  ));
            },
            icon: const Icon(
              Icons.bookmark,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder<dynamic>(
        stream: _netBloc.connectivityResultStream.asBroadcastStream(),
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
              _bloc.fetchMusicList();

              return RefreshIndicator(
                onRefresh: () => _bloc.fetchMusicList(),
                child: StreamBuilder<dynamic>(
                  stream: _bloc.musicListStream.asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return Loading(loadingMessage: snapshot.data.message);
                        case Status.COMPLETED:
                          return TrackList(musicList: snapshot.data.data);
                        case Status.ERROR:
                          break;
                      }
                    }
                    return const Loading(loadingMessage: 'Connecting');
                  },
                ),
              );
            case ConnectivityResult.none:
              return const Center(
                child: Text(
                  'No Internet Connection',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _netBloc.dispose();
    _bloc.dispose();
    super.dispose();
  }
}

class TrackList extends StatelessWidget {
  final MusicList musicList;
  const TrackList({Key? key, required this.musicList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          Track? track = musicList.message!.body!.trackList![index].track;
          return TrackTile(
            track: track!,
          );
        },
        itemCount: musicList.message!.body!.trackList!.length,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key? key, required this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
          const SizedBox(
            height: 24,
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          )
        ],
      ),
    );
  }
}

class TrackTile extends StatelessWidget {
  final Track track;

  const TrackTile({
    Key? key,
    required this.track,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //debugPrint('Calling for trackid ${track.trackId}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetMusicLyrics(
                      trackCurrent: track,
                    )));
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          leading: const Icon(Icons.library_music, size: 20),
          title: Text(track.trackName,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          subtitle: Text(
            track.albumName,
            style: const TextStyle(fontSize: 12, ),
          ),
          trailing: SizedBox(
            width: 100,
            child: Text(
              track.artistName,
              softWrap: true,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
