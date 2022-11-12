// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SimpleMusicPlayer(),
    );
  }
}

class SimpleMusicPlayer extends StatefulWidget {
  const SimpleMusicPlayer({super.key});

  @override
  State<SimpleMusicPlayer> createState() => _SimpleMusicPlayerState();
}

class _SimpleMusicPlayerState extends State<SimpleMusicPlayer> {
  final OnAudioQuery audioQueryValue = OnAudioQuery();
  final AudioPlayer audioPlayerValue = AudioPlayer();

  playSong(String? uri) {
    try {
      audioPlayerValue.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      audioPlayerValue.play();
    } on Exception {
      log("Error parsing lagune cak");
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player 2022'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQueryValue.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return Center(child: Text("Tidak ada music yang ditemukan"));
          }
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(item.data![index].displayNameWOExt),
              subtitle: Text("${item.data![index].artist}"),
              trailing: Icon(Icons.more_horiz),
              leading: CircleAvatar(
                backgroundColor: Colors.amber.shade600,
                child: Icon(Icons.music_note),
              ),
              onTap: () {
                playSong(item.data![index].uri);
              },
            ),
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }
}
