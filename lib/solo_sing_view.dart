import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:lyrics_parser/lyrics_parser.dart';
import 'package:star/constant.dart';
import 'package:star/solo/lyrics.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class SoloSingView extends StatefulWidget {
  final String roomID;
  final String userID;
  final bool isHost;
  const SoloSingView({
    Key? key,
    required this.roomID,
    required this.userID,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<SoloSingView> createState() => _SoloSingViewState();
}

class _SoloSingViewState extends State<SoloSingView> {
  String userID = "";
  String roomID = "";
  String userName = "";
  String singerCurrentLyrics = "";
  String currentLyrics = "";
  bool isHost = false;
  Map<Duration, String>? lyrics;

  ZegoEngineProfile profile = ZegoEngineProfile(
    653933933,
    ZegoScenario.Karaoke,
    appSign: "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
  );

  ZegoMediaPlayer? player;

  loginRoom() async {
    await ZegoExpressEngine.createEngineWithProfile(profile);
    setEventHandler();
    userID = widget.userID;
    userName = widget.userID + '_user';
    roomID = widget.roomID;
    isHost = widget.isHost;
    ZegoUser user = ZegoUser(userID, userName);
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
      ..isUserStatusNotify = true;
    await ZegoExpressEngine.instance
        .loginRoom(roomID, user, config: roomConfig);
    if (isHost) {
      await createMediaPlayer();
    }
    setState(() {});
  }

  loadLyrics() async {
    var parser = LyricsParser(lyricsContent);
    final result = await parser.parse();
    ZegoExpressEngine.instance;
    lyrics = await parseLyrics(result.lyricList);
    setState(() {});
  }

  Future<Map<Duration, String>> parseLyrics(lyrics) async {
    Map<Duration, String> lyricsTimingMap = {};
    for (final lcr in lyrics) {
      Duration timestamp = Duration(
          milliseconds: int.parse(lcr.startTimeMillisecond.toString()));
      lyricsTimingMap[timestamp] = lcr.content;
    }
    return lyricsTimingMap;
  }

  void onRoomStateUpdated(String roomID, ZegoUpdateType updateType,
      List<ZegoStream> streamList, extendedData) {
    ZegoStream stream = streamList.first;
    String playStreamID = stream.streamID;
    if (updateType == ZegoUpdateType.Add) {
      ZegoExpressEngine.instance
          .setPlayStreamBufferIntervalRange(playStreamID, 500, 4000);
      ZegoExpressEngine.instance.startPlayingStream(playStreamID);
    } else {
      ZegoExpressEngine.instance.stopPlayingStream(playStreamID);
    }
  }

  void onPlayerRecvSEI(String streamID, Uint8List data) {
    String dataString = utf8.decode(data);
    try {
      Map<String, dynamic> jsonObject = jsonDecode(dataString);
      String KEY_PROGRESS_IN_MS = "KEY_PROGRESS_IN_MS";
      int progress = jsonObject[KEY_PROGRESS_IN_MS];
       Duration currentDuration = Duration(milliseconds: progress);

    var previousTimestamps =
        lyrics!.keys.where((k) => k as Duration <= currentDuration);

    if (previousTimestamps.isNotEmpty) {
      Duration latestTimestamp =
          previousTimestamps.reduce((Duration a, Duration b) => a > b ? a : b);

      setState(() {
        currentLyrics = lyrics![latestTimestamp] ?? '';
      });
    }
     
    } catch (e) {
      print(e);
    }
  }

  void onIMRecvCustomCommand(
      String roomID, ZegoUser fromUser, String command) {}

  setEventHandler() async {
    ZegoExpressEngine.onRoomStreamUpdate = onRoomStateUpdated;
    ZegoExpressEngine.onPlayerRecvSEI = onPlayerRecvSEI;
    ZegoExpressEngine.onIMRecvCustomCommand = onIMRecvCustomCommand;
  }

  void onMediaPlayerPlayingProgress(
      ZegoMediaPlayer player, int miliseconds) async {
    Duration currentDuration = Duration(milliseconds: miliseconds);

    var previousTimestamps =
        lyrics!.keys.where((k) => k as Duration <= currentDuration);

    if (previousTimestamps.isNotEmpty) {
      Duration latestTimestamp =
          previousTimestamps.reduce((Duration a, Duration b) => a > b ? a : b);

      setState(() {
        singerCurrentLyrics = lyrics![latestTimestamp] ?? '';
      });
    }
    // Send SEI infomations
    sendSEIMessage(miliseconds);
  }

  onMediaPlayerStateUpdate(ZegoMediaPlayer mediaPlayer,
      ZegoMediaPlayerState state, int errorCode) async {
    if (state == ZegoMediaPlayerState.PlayEnded) {
      // stopSinging();
    }
  }

  loadMusicResource() async {
    await player!
        .loadResource(
            'https://drive.usercontent.google.com/u/0/uc?id=10BZKh-i7PGEVZAIlD-jwb4HUMHjMtsw9&export=download')
        .then((value) => {
              if (value.errorCode == 0) {player!.start()}
            });
  }

  void startSinging() async {
    await loadMusicResource();
    Random random = new Random();
    int randomInt = random.nextInt(1000);
    String streamID = "stream1" + randomInt.toString();

    await ZegoExpressEngine.instance.muteMicrophone(false);
    await ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  createMediaPlayer() async {
    ZegoMediaPlayer? mediaPlayer =
        await ZegoExpressEngine.instance.createMediaPlayer();
    if (mediaPlayer == null) {
      return;
    }

    player = mediaPlayer;
    player!.enableAux(true);

    ZegoExpressEngine.onMediaPlayerPlayingProgress =
        onMediaPlayerPlayingProgress;
    ZegoExpressEngine.onMediaPlayerStateUpdate = onMediaPlayerStateUpdate;
    setState(() {});
  }

  void sendSEIMessage(int millisecond) {
    try {
      Map<String, dynamic> localMusicProcessStatusJsonObject = {
        'KEY_PROGRESS_IN_MS': millisecond,
      };
      String jsonData = jsonEncode(localMusicProcessStatusJsonObject);
      Uint8List data = utf8.encode(jsonData);
      ZegoExpressEngine.instance.sendSEI(data, data.length);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    loginRoom();
    loadLyrics();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          isHost
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    singerCurrentLyrics,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    currentLyrics,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
          isHost
              ? MaterialButton(
                  child: Text('Start Singing'),
                  onPressed: () {
                    startSinging();
                  },
                )
              : Text(''),
        ],
      )),
    );
  }
}
