import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:music_lyrics/models/music_list.dart'as ListTrack;
import 'package:music_lyrics/networking/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/connectivity_bloc.dart';
import '../blocs/music_details_bloc.dart';
import '../blocs/music_lyrics_bloc.dart';
import '../models/music_details.dart';
import 'music_list_view.dart';

class GetMusicLyrics extends StatefulWidget {
   final ListTrack.Track trackCurrent;

  const GetMusicLyrics({Key? key, required this.trackCurrent, }) : super(key: key);

  @override
  State<GetMusicLyrics> createState() => _GetMusicLyricsState();
}

class _GetMusicLyricsState extends State<GetMusicLyrics> {
   ConnectivityBloc? _netBloc;
  MusicDetailsBloc? _bloc;

 @override
  void initState() {
    super.initState();
    _netBloc = ConnectivityBloc();
    _bloc = MusicDetailsBloc(trackId: widget.trackCurrent.trackId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: LyricAppBar(
            track: widget.trackCurrent,
          )),
      body: StreamBuilder<dynamic>(
          stream: _netBloc!.connectivityResultStream.asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data) {
                case ConnectivityResult.mobile:
                case ConnectivityResult.wifi:
                  _bloc!.fetchMusicDetails();
                  //print('NET2 : ');
                  return RefreshIndicator(
                    onRefresh: () => _bloc!.fetchMusicDetails(),
                    child: StreamBuilder<dynamic>(
                      stream: _bloc!.musicDetailsStream.asBroadcastStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return Loading(
                                loadingMessage: snapshot.data.message,
                              );
                            case Status.COMPLETED:
                              return TrackDetails(
                                musicDetails: snapshot.data.data,
                                trackId: widget.trackCurrent.trackId,
                              );
                            case Status.ERROR:
                              return const Text('Errror');
                          }
                        }
                        return const Loading(
                          loadingMessage: 'Connecting',
                        );
                      },
                    ),
                  );
                case ConnectivityResult.none:
                  //print('No Net : ');
                  return const Center(
                    child: Text('No internet'),
                  );
              }
            }
            return const Text('Check Connectivity object');
          }),
    );
  }

  @override
  void dispose() {
    _netBloc?.dispose();
    _bloc?.dispose();
    super.dispose();
  }
}

class TrackDetails extends StatefulWidget {
  final MusicDetails musicDetails;
  final int trackId;
   // ignore: use_key_in_widget_constructors
   const TrackDetails({ required this.musicDetails,  required this.trackId});

  @override
  // ignore: library_private_types_in_public_api
  _TrackDetailsState createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
   MusicLyricsBloc? _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = MusicLyricsBloc(trackId: widget.trackId);
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       Track? track = widget.musicDetails.message?.body?.track;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          InfoTile(
            heading: 'Name',
            body: track!.trackName,
            
          ),
          InfoTile(
            heading: 'Artist',
            body: track.artistName,
          ),
          InfoTile(
            heading: 'Album Name',
            body: track.albumName,
          ),
          InfoTile(
            heading: 'Explicit',
            body: track.explicit == 1 ? 'True' : 'False',
          ),
          InfoTile(
            heading: 'Rating',
            body: track.trackRating.toString(),
          ),


          StreamBuilder<dynamic>(
              stream: _bloc!.musicLyricsStream.asBroadcastStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Loading(
                        loadingMessage: snapshot.data.message,
                      );
                    case Status.COMPLETED:
                      return InfoTile(
                        heading: 'Lyrics',
                        body: snapshot.data.data.message.body.lyrics.lyricsBody,
                      );
                    case Status.ERROR:
                      break;
                  }
                }
                return const Loading(
                  loadingMessage: '',
                );
              })
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class InfoTile extends StatelessWidget {
   String? heading;
   String body;
  InfoTile({Key? key, this.heading, required this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(
          height: 15.0,
        ),
        Text(
          heading!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          body,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class LyricAppBar extends StatefulWidget {
   ListTrack.Track? track;
  LyricAppBar({Key? key,  this.track}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LyricAppBarState createState() => _LyricAppBarState();
}

class _LyricAppBarState extends State<LyricAppBar> {
  IconData bookmarkIcon = Icons.bookmark_border;
  bool changed = false;
  void checkBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList('bookmarkList') ?? [];
    setState(() {
      if (stringList.contains(widget.track!.trackId.toString())) {
        bookmarkIcon = Icons.bookmark;
      } else {
        bookmarkIcon = Icons.bookmark_border;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // backgroundColor: Colors.red,
      elevation: 5.0,
      centerTitle: true,
      title: const Text(
        'Track Details',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            bookmarkIcon,
            color: Colors.black,
          ),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final trackIDList = prefs.getStringList('bookmarkList') ?? [];
            final trackNameList = prefs.getStringList('nameList') ?? [];
            final trackAlbumList = prefs.getStringList('albumList') ?? [];
            final trackArtistList = prefs.getStringList('artistList') ?? [];
            setState(() {
              changed = true;
              if (bookmarkIcon == Icons.bookmark_border) {
                bookmarkIcon = Icons.bookmark;
                trackIDList.add(widget.track!.trackId.toString());
                trackNameList.add(widget.track!.trackName.toString());
                trackAlbumList.add(widget.track!.albumName.toString());
                trackArtistList.add(widget.track!.artistName.toString());
              } else {
                bookmarkIcon = Icons.bookmark_border;
                if (prefs.containsKey('bookmarkList') &&
                    trackIDList.contains(widget.track!.trackId.toString())) {
                  int index =
                      trackIDList.indexOf(widget.track!.trackId.toString());
                  trackIDList.removeAt(index);
                  trackNameList.removeAt(index);
                  trackAlbumList.removeAt(index);
                  trackArtistList.removeAt(index);
                }
              }
              prefs.setStringList('bookmarkList', trackIDList);
              prefs.setStringList('nameList', trackNameList);
              prefs.setStringList('albumList', trackAlbumList);
              prefs.setStringList('artistList', trackArtistList);
            });
            //print(trackIDList.toString());
            //print(trackNameList.toString());
            //print(trackAlbumList.toString());
            //print(trackArtistList.toString());
          },
        )
      ],
    );
}
}