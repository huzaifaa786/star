import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lyrics_parser/lyrics_parser.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class LyricsView extends StatefulWidget {
  @override
  _LyricsViewState createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView>
    with SingleTickerProviderStateMixin {
  String musicFileUrl =
      'https://github.com/m-abdurehman/testData/blob/main/love.mp3';
  String lyricsFileUrl =
      'https://github.com/m-abdurehman/testData/blob/main/love.lrc';
  String _currentLyrics = '';
  ZegoMediaPlayer? mediaPlayer;
  void initZego() async {
    ZegoEngineProfile profile = ZegoEngineProfile(
      653933933,
      ZegoScenario.Karaoke,
      appSign:
          "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
    );
    await ZegoExpressEngine.createEngineWithProfile(profile);

    // Download and parse lyrics
    // String lyricsContent = await downloadFile(lyricsFileUrl);
    String lyricsContent = '''[00:00.000] 作词 : TritecKodes
[00:01.000] 作曲 : TritecKodes Presents
[00:11.210]It's been a long day without you my friend
[00:17.310]And I'll tell you all about it when I see you again
[00:23.750]We've come a long way from where we began
[00:29.250]Oh I'll tell you all about it when I see you again
[00:35.700]When I see you again
[00:40.200]Damn who knew all the planes we flew
[00:43.550]Good things we've been through
[00:44.850]That I'll be standing right here
[00:46.950]Talking to you about another path
[00:47.900]I know we loved to hit the road and laugh
[00:51.800]But something told me that it wouldn't last
[00:53.900]Had to switch up look at things different see the bigger picture
[00:57.750]Those were the days hard work forever pays
[01:00.650]Now I see you in a better place
[01:05.700]How could we not talk about family when family's all that we got?
[01:09.200]Everything I went through you were standing there by my side
[01:11.950]And now you gonna be with me for the last ride
[01:14.600]It's been a long day without you my friend
[01:20.900]And I'll tell you all about it when I see you again
[01:27.100]We've come a long way from where we began
[01:32.950]Oh I'll tell you all about it when I see you again
[01:38.700]When I see you again
[01:42.150]Ohh~~~
[01:57.050]First you both go out your way
[01:58.050]And the vibe is feeling strong and what's small turn to a friendship
[02:01.450]a friendship turn into a bond and
[02:03.650]that bond will never be broke and the love will never get lost
[02:09.250]And when brotherhood come first then the line
[02:11.350]Will never be crossed established it on our own
[02:12.850]When that line had to be drawn and that line is what we reach
[02:17.650]So remember me when I'm gone
[02:20.550]How could we not talk about family when family's all that we got?
[02:24.650]Everything I went through you were standing there by my side
[02:27.800]And now you gonna be with me for the last ride
[02:30.100]Let the light guide your way
[02:36.950]Hold every memory as you go
[02:42.150]And every road you take will always lead you home
[02:50.350]Hoo
[02:53.450]It's been a long day without you my friend
[02:59.650]And I'll tell you all about it when I see you again
[03:05.850]We've come a long way from where we began
[03:11.800]Oh I'll tell you all about it when I see you again
[03:17.850]When I see you again
[03:26.550]Again
[03:31.750]When I see you again see you again
[03:42.500]When I see you again''';

    // Map<Duration, String> lyricsTimingMap = await parseLyrics(lyricsContent);
    var parser = LyricsParser(lyricsContent);
    final result = await parser.parse();
    ZegoExpressEngine.instance;
    final lyrics = await parseLyrics(result.lyricList);

    for (var lyric in result.lyricList) {
      print('COMMENT: ');
      print(lyric.content.toString());
      print(lyric.startTimeMillisecond.toString());
      print(Duration(milliseconds: lyric.startTimeMillisecond!.toInt())
          .inSeconds);
    }
    mediaPlayer = await ZegoExpressEngine.instance.createMediaPlayer();
    if (mediaPlayer != null) {
      await mediaPlayer!
          .loadResource("https://musicdownload.cc/files/download/id/163")
          .then((ZegoMediaPlayerLoadResourceResult result) {
        print('AAAAAAAAAAAAAAAAA');
        print(result.errorCode);
        if (result.errorCode == 0) {
          playMusicAndSyncLyrics(mediaPlayer!, lyrics);
        } else {
          // loadResource errorcode: errorcode
        }
      });
    } else {}
  }

// Function to download files from URL
  Future<String> downloadFile(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to download file');
    }
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

  void playMusicAndSyncLyrics(ZegoMediaPlayer player, lyricsTimingMap) {
    player.start();
    _startSinging();
    Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      player.getCurrentProgress().then((currentPosition) {
        Duration currentDuration = Duration(milliseconds: currentPosition);

        var previousTimestamps =
            lyricsTimingMap.keys.where((k) => k as Duration <= currentDuration);

        if (previousTimestamps.isNotEmpty) {
          Duration latestTimestamp = previousTimestamps
              .reduce((Duration a, Duration b) => a > b ? a : b);
          print('latest timestamp: ' + latestTimestamp.toString());
          print(_currentLyrics);
          setState(() {
            _currentLyrics = lyricsTimingMap[latestTimestamp] ?? '';
          });
        }
      });
    });
  }

  void _startSinging() async {
    // // Configure audio reverb
    // _audioReverbParam!.roomSize = 0.3;
    // _audioReverbParam!.preDelay = 20;

    // Set other reverb parameters as needed

    // ZegoExpressEngine.instance.setReverbAdvancedParam(_audioReverbParam!);

    // Start the microphone
    ZegoRangeAudio? audio = await ZegoExpressEngine.instance.createRangeAudio();
    audio!.enableMicrophone(true);

    // Start publishing the audio stream
    ZegoExpressEngine.instance.startPublishingStream('HELLLLLo');
  }

  @override
  void initState() {
    initZego();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _currentLyrics,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            MaterialButton(
                child: Text('Pause'),
                onPressed: () {
                  mediaPlayer!.pause();
                }),
            MaterialButton(
                child: Text('Resume'),
                onPressed: () {
                  mediaPlayer!.resume();
                }),
            MaterialButton(
                child: Text('Back'),
                onPressed: () {
                  ZegoExpressEngine.instance.destroyMediaPlayer(mediaPlayer!);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  // Widget buildContainer() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       buildReaderWidget(),
  //       Expanded(
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               ...buildPlayControl(),
  //               ...buildUIControl(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // var lyricPadding = 40.0;

  // Stack buildReaderWidget() {
  //   return Stack(
  //     children: [
  //       ...buildReaderBackground(),
  //       LyricsReader(
  //         padding: EdgeInsets.symmetric(horizontal: lyricPadding),
  //         model: lyricModel,
  //         position: playProgress,
  //         lyricUi: lyricUI,
  //         playing: playing,
  //         size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
  //         emptyBuilder: () => Center(
  //           child: Text(
  //             "No lyrics",
  //             style: lyricUI.getOtherMainTextStyle(),
  //           ),
  //         ),
  //         selectLineBuilder: (progress, confirm) {
  //           return Row(
  //             children: [
  //               IconButton(
  //                   onPressed: () {
  //                     LyricsLog.logD("点击事件");
  //                     confirm.call();
  //                     setState(() {
  //                       audioPlayer?.seek(Duration(milliseconds: progress));
  //                     });
  //                   },
  //                   icon: Icon(Icons.play_arrow, color: Colors.green)),
  //               Expanded(
  //                 child: Container(
  //                   decoration: BoxDecoration(color: Colors.green),
  //                   height: 1,
  //                   width: double.infinity,
  //                 ),
  //               ),
  //               Text(
  //                 progress.toString(),
  //                 style: TextStyle(color: Colors.green),
  //               )
  //             ],
  //           );
  //         },
  //       )
  //     ],
  //   );
  // }

  // List<Widget> buildPlayControl() {
  //   return [
  //     Container(
  //       height: 20,
  //     ),
  //     Text(
  //       "Progress:$sliderProgress",
  //       style: TextStyle(
  //         fontSize: 16,
  //         color: Colors.green,
  //       ),
  //     ),
  //     if (sliderProgress < max_value)
  //       Slider(
  //         min: 0,
  //         max: max_value,
  //         label: sliderProgress.toString(),
  //         value: sliderProgress,
  //         activeColor: Colors.blueGrey,
  //         inactiveColor: Colors.blue,
  //         onChanged: (double value) {
  //           setState(() {
  //             sliderProgress = value;
  //           });
  //         },
  //         onChangeStart: (double value) {
  //           isTap = true;
  //         },
  //         onChangeEnd: (double value) {
  //           isTap = false;
  //           setState(() {
  //             playProgress = value.toInt();
  //           });
  //           audioPlayer?.seek(Duration(milliseconds: value.toInt()));
  //         },
  //       ),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         TextButton(
  //             onPressed: () async {
  //               if (audioPlayer == null) {
  //                 audioPlayer = AudioPlayer()..play(AssetSource("music1.mp3"));
  //                 setState(() {
  //                   playing = true;
  //                 });
  //                 audioPlayer?.onDurationChanged.listen((Duration event) {
  //                   setState(() {
  //                     max_value = event.inMilliseconds.toDouble();
  //                   });
  //                 });
  //                 audioPlayer?.onPositionChanged.listen((Duration event) {
  //                   if (isTap) return;
  //                   setState(() {
  //                     sliderProgress = event.inMilliseconds.toDouble();
  //                     playProgress = event.inMilliseconds;
  //                   });
  //                 });

  //                 audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
  //                   setState(() {
  //                     playing = state == PlayerState.playing;
  //                   });
  //                 });
  //               } else {
  //                 audioPlayer?.resume();
  //               }
  //             },
  //             child: Text("Play")),
  //         Container(
  //           width: 10,
  //         ),
  //         TextButton(
  //             onPressed: () async {
  //               audioPlayer?.pause();
  //             },
  //             child: Text("Pause")),
  //         Container(
  //           width: 10,
  //         ),
  //         TextButton(
  //             onPressed: () async {
  //               audioPlayer?.stop();
  //               audioPlayer = null;
  //             },
  //             child: Text("Stop")),
  //       ],
  //     ),
  //   ];
  // }

  // var playing = false;

  // List<Widget> buildReaderBackground() {
  //   return [
  //     Positioned.fill(
  //       child: Image.asset(
  //         "bg.jpeg",
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     Positioned.fill(
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //         child: Container(
  //           color: Colors.black.withOpacity(0.3),
  //         ),
  //       ),
  //     )
  //   ];
  // }

  // var mainTextSize = 18.0;
  // var extTextSize = 16.0;
  // var lineGap = 16.0;
  // var inlineGap = 10.0;
  // var lyricAlign = LyricAlign.CENTER;
  // var highlightDirection = HighlightDirection.LTR;

  // List<Widget> buildUIControl() {
  //   return [
  //     Container(
  //       height: 30,
  //     ),
  //     Text("UI setting", style: TextStyle(fontWeight: FontWeight.bold)),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Checkbox(
  //             value: lyricUI.enableHighlight(),
  //             onChanged: (value) {
  //               setState(() {
  //                 lyricUI.highlight = (value ?? false);
  //                 refreshLyric();
  //               });
  //             }),
  //         Text("enable highLight"),
  //         Checkbox(
  //             value: useEnhancedLrc,
  //             onChanged: (value) {
  //               setState(() {
  //                 useEnhancedLrc = value!;
  //                 lyricModel = LyricsModelBuilder.create()
  //                     .bindLyricToMain(value ? advancedLyric : normalLyric)
  //                     .bindLyricToExt(transLyric)
  //                     .getModel();
  //               });
  //             }),
  //         Text("use Enhanced lrc")
  //       ],
  //     ),
  //     buildTitle("highlight direction"),
  //     Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: HighlightDirection.values
  //           .map(
  //             (e) => Expanded(
  //                 child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 children: [
  //                   Radio<HighlightDirection>(
  //                       activeColor: Colors.orangeAccent,
  //                       value: e,
  //                       groupValue: highlightDirection,
  //                       onChanged: (v) {
  //                         setState(() {
  //                           highlightDirection = v!;
  //                           lyricUI.highlightDirection = highlightDirection;
  //                           refreshLyric();
  //                         });
  //                       }),
  //                   Text(e.toString().split(".")[1])
  //                 ],
  //               ),
  //             )),
  //           )
  //           .toList(),
  //     ),
  //     buildTitle("lyric padding"),
  //     Slider(
  //       min: 0,
  //       max: 100,
  //       label: lyricPadding.toString(),
  //       value: lyricPadding,
  //       activeColor: Colors.blueGrey,
  //       inactiveColor: Colors.blue,
  //       onChanged: (double value) {
  //         setState(() {
  //           lyricPadding = value;
  //         });
  //       },
  //     ),
  //     buildTitle("lyric primary text size"),
  //     Slider(
  //       min: 15,
  //       max: 30,
  //       label: mainTextSize.toString(),
  //       value: mainTextSize,
  //       activeColor: Colors.blueGrey,
  //       inactiveColor: Colors.blue,
  //       onChanged: (double value) {
  //         setState(() {
  //           mainTextSize = value;
  //         });
  //       },
  //       onChangeEnd: (double value) {
  //         setState(() {
  //           lyricUI.defaultSize = mainTextSize;
  //           refreshLyric();
  //         });
  //       },
  //     ),
  //     buildTitle("lyric secondary text size"),
  //     Slider(
  //       min: 15,
  //       max: 30,
  //       label: extTextSize.toString(),
  //       value: extTextSize,
  //       activeColor: Colors.blueGrey,
  //       inactiveColor: Colors.blue,
  //       onChanged: (double value) {
  //         setState(() {
  //           extTextSize = value;
  //         });
  //       },
  //       onChangeEnd: (double value) {
  //         setState(() {
  //           lyricUI.defaultExtSize = extTextSize;
  //           refreshLyric();
  //         });
  //       },
  //     ),
  //     buildTitle("lyric line spacing"),
  //     Slider(
  //       min: 10,
  //       max: 80,
  //       label: lineGap.toString(),
  //       value: lineGap,
  //       activeColor: Colors.blueGrey,
  //       inactiveColor: Colors.blue,
  //       onChanged: (double value) {
  //         setState(() {
  //           lineGap = value;
  //         });
  //       },
  //       onChangeEnd: (double value) {
  //         setState(() {
  //           lyricUI.lineGap = lineGap;
  //           refreshLyric();
  //         });
  //       },
  //     ),
  //     buildTitle("primary and secondary lyric spacing"),
  //     Slider(
  //       min: 10,
  //       max: 80,
  //       label: inlineGap.toString(),
  //       value: inlineGap,
  //       activeColor: Colors.blueGrey,
  //       inactiveColor: Colors.blue,
  //       onChanged: (double value) {
  //         setState(() {
  //           inlineGap = value;
  //         });
  //       },
  //       onChangeEnd: (double value) {
  //         setState(() {
  //           lyricUI.inlineGap = inlineGap;
  //           refreshLyric();
  //         });
  //       },
  //     ),
  //     buildTitle("select line bias"),
  //     Slider(
  //       min: 0.3,
  //       max: 0.8,
  //       label: bias.toString(),
  //       value: bias,
  //       activeColor: Colors.blueGrey,
  //       inactiveColor: Colors.blue,
  //       onChanged: (double value) {
  //         setState(() {
  //           bias = value;
  //         });
  //       },
  //       onChangeEnd: (double value) {
  //         setState(() {
  //           lyricUI.bias = bias;
  //           refreshLyric();
  //         });
  //       },
  //     ),
  //     buildTitle("lyric align"),
  //     Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: LyricAlign.values
  //           .map(
  //             (e) => Expanded(
  //                 child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 children: [
  //                   Radio<LyricAlign>(
  //                       activeColor: Colors.orangeAccent,
  //                       value: e,
  //                       groupValue: lyricAlign,
  //                       onChanged: (v) {
  //                         setState(() {
  //                           lyricAlign = v!;
  //                           lyricUI.lyricAlign = lyricAlign;
  //                           refreshLyric();
  //                         });
  //                       }),
  //                   Text(e.toString().split(".")[1])
  //                 ],
  //               ),
  //             )),
  //           )
  //           .toList(),
  //     ),
  //     buildTitle("select line base"),
  //     Row(
  //       children: LyricBaseLine.values
  //           .map((e) => Expanded(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Column(
  //                     children: [
  //                       Radio<LyricBaseLine>(
  //                           activeColor: Colors.orangeAccent,
  //                           value: e,
  //                           groupValue: lyricBiasBaseLine,
  //                           onChanged: (v) {
  //                             setState(() {
  //                               lyricBiasBaseLine = v!;
  //                               lyricUI.lyricBaseLine = lyricBiasBaseLine;
  //                               refreshLyric();
  //                             });
  //                           }),
  //                       Text(e.toString().split(".")[1])
  //                     ],
  //                   ),
  //                 ),
  //               ))
  //           .toList(),
  //     ),
  //   ];
  // }

  // void refreshLyric() {
  //   lyricUI = UINetease.clone(lyricUI);
  // }

  // var bias = 0.5;
  // var lyricBiasBaseLine = LyricBaseLine.CENTER;

  // Text buildTitle(String title) => Text(title,
  //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
}
