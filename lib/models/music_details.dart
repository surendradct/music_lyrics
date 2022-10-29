class MusicDetails {
  Message? message;

  MusicDetails({required this.message});

  MusicDetails.fromJson(Map<String, dynamic> json,  trackId) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  Header? header;
  Body? body;

  Message({required this.header, required this.body});

  Message.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? Header.fromJson(json['header']) : null;
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (header != null) {
      data['header'] = header!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Header {
  int? statusCode;
  double? executeTime;

  Header({required this.statusCode, required this.executeTime});

  Header.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    executeTime = json['execute_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['execute_time'] = executeTime;
    return data;
  }
}

class Body {
  Track? track;

  Body({track});

  Body.fromJson(Map<String, dynamic> json) {
    track = json['track'] != null ? Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (track != null) {
      data['track'] = track!.toJson();  
    }
    return data;
  }
}

class Track {
  late int trackId;
  late String trackName;
  List<void>? trackNameTranslationList;
  int? trackRating;
  int? commontrackId;
  int? instrumental;
  int? explicit;
  int? hasLyrics;
  int? hasSubtitles;
  int? hasRichsync;
  int? numFavourite;
  int? albumId;
  late String albumName;
  int? artistId;
  late String artistName;
 late  String trackShareUrl;
  String? trackEditUrl;
  int? restricted;
  String? updatedTime;
  PrimaryGenres? primaryGenres;

  Track(
      {required this.trackId,
      required this.trackName,
      trackNameTranslationList,
      trackRating,
      commontrackId,
      instrumental,
      explicit,
      hasLyrics,
      hasSubtitles,
      hasRichsync,
      numFavourite,
      albumId,
      required this.albumName,
      artistId,
      required this.artistName,
      required this.trackShareUrl,
      trackEditUrl,
      restricted,
      updatedTime,
      primaryGenres});

  Track.fromJson(Map<String, dynamic> json) {
    trackId = json['track_id'];
    trackName = json['track_name'];
    trackRating = json['track_rating'];
    commontrackId = json['commontrack_id'];
    instrumental = json['instrumental'];
    explicit = json['explicit'];
    hasLyrics = json['has_lyrics'];
    hasSubtitles = json['has_subtitles'];
    hasRichsync = json['has_richsync'];
    numFavourite = json['num_favourite'];
    albumId = json['album_id'];
    albumName = json['album_name'];
    artistId = json['artist_id'];
    artistName = json['artist_name'];
    trackShareUrl = json['track_share_url'];
    trackEditUrl = json['track_edit_url'];
    restricted = json['restricted'];
    updatedTime = json['updated_time'];
    primaryGenres = json['primary_genres'] != null
        ? PrimaryGenres.fromJson(json['primary_genres'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['track_id'] = trackId;
    data['track_name'] = trackName;
    data['track_rating'] = trackRating;
    data['commontrack_id'] = commontrackId;
    data['instrumental'] = instrumental;
    data['explicit'] = explicit;
    data['has_lyrics'] = hasLyrics;
    data['has_subtitles'] = hasSubtitles;
    data['has_richsync'] = hasRichsync;
    data['num_favourite'] = numFavourite;
    data['album_id'] = albumId;
    data['album_name'] = albumName;
    data['artist_id'] = artistId;
    data['artist_name'] = artistName;
    data['track_share_url'] = trackShareUrl;
    data['track_edit_url'] = trackEditUrl;
    data['restricted'] = restricted;
    data['updated_time'] = updatedTime;
    if (primaryGenres != null) {
      data['primary_genres'] = primaryGenres!.toJson();
    }
    return data;
  }
}

class PrimaryGenres {
  List<void>? musicGenreList;

  PrimaryGenres({required this.musicGenreList});

  PrimaryGenres.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}
