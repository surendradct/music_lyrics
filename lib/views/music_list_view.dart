import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_lyrics/blocs/connectivity_bloc.dart';
import 'package:music_lyrics/blocs/music_list_bloc.dart';
import 'package:music_lyrics/models/music_list.dart';
import 'package:music_lyrics/networking/response.dart';
import 'package:music_lyrics/views/bookmark_view.dart';

import 'music_lyrics_view.dart';

class GetMusicList extends StatefulWidget {
  const GetMusicList({Key? key}) : super(key: key);

  @override
  State<GetMusicList> createState() => _GetMusicListState();
}

class _GetMusicListState extends State<GetMusicList> {
  final ConnectivityBloc _netBloc = ConnectivityBloc();
  final MusicListBloc _bloc = MusicListBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              Icons.bookmark, color: Colors.black,
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
                          return Loading(
                            loadingMessage: snapshot.data.message);
                          break;
                        case Status.COMPLETED:
                          return TrackList(
                            musicList: snapshot.data.data
                            );
                          break;
                        case Status.ERROR:
                          break;
                      }
                    }
                    return const Loading(loadingMessage: 'Connecting');
                  },
                ),
              );
              break;
            case ConnectivityResult.none:
              return const Center(
                child: Text('No Internet'),
              );
              break;
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
        children:<Widget> [
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black26, width: 1.0),
            ),
          ),
          child: ListTile(
            leading: const Icon(Icons.library_music),
            title: Text(track.trackName),
              subtitle: Text(track.albumName),
              trailing: Container(
                width: 110,
                child: Text(track.artistName, softWrap: true,),
                
              ),
          ),
        ),
      ),
    );
  }
}
