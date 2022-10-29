import 'package:flutter/material.dart';
import 'package:music_lyrics/views/music_list_view.dart';
 void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'music_lyrics',
      home: GetMusicList(),
    );
  }
}