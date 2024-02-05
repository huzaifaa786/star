// Flutter imports:

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:lyrics_parser/lyrics_parser.dart';
import 'package:star/constant.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

// Project imports:

import 'media.dart';

class LivePage extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final LayoutMode layoutMode;

  const LivePage({
    Key? key,
    required this.roomID,
    this.layoutMode = LayoutMode.defaultLayout,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final liveController = ZegoLiveAudioRoomController();
  Widget? localView;
  int? localViewID;
  Widget? remoteView;
  int? remoteViewID;
  String _currentLyrics = '';
  ZegoMediaPlayer? mediaPlayer;
  ZegoEngineProfile profile = ZegoEngineProfile(
    653933933,
    ZegoScenario.Broadcast,
    appSign: "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
  );

  // lyrics
  double sliderProgress = 0;
  int playProgress = 0;
  double AudiencEsliderProgress = 0;
  int AudienceplayProgress = 0;
  double max_value = 211658;
  bool isTap = false;
  bool useEnhancedLrc = false;
  var lyricModel =
      LyricsModelBuilder.create().bindLyricToMain(lyricsContent).getModel();
  var lyricUI = UINetease();
  var playing = false;

  var result;

  void initZego() async {
    // await ZegoExpressEngine.createEngineWithProfile(profile);
    // var parser = LyricsParser(lyricsContent);
    // final result = await parser.parse();
    // ZegoExpressEngine.instance;
    // final lyrics = await parseLyrics(result.lyricList);

    // if (mediaPlayer != null) {
    //   await mediaPlayer!
    //       .loadResource(
    //           "https://drive.usercontent.google.com/u/0/uc?id=10BZKh-i7PGEVZAIlD-jwb4HUMHjMtsw9&export=download")
    //       .then((ZegoMediaPlayerLoadResourceResult result) {
    //     if (result.errorCode == 0) {
    //       playMusicAndSyncLyrics(mediaPlayer!, lyrics);
    //     } else {
    //       // loadResource errorcode: errorcode
    //     }
    //   });
    // } else {}
  }

  void playSong() async {
    mediaPlayer = await ZegoExpressEngine.instance.createMediaPlayer();
    if (mediaPlayer != null) {
      await mediaPlayer!.enableAux(true);
      await mediaPlayer!
          .loadResource(
              "https://drive.usercontent.google.com/u/0/uc?id=10BZKh-i7PGEVZAIlD-jwb4HUMHjMtsw9&export=download")
          .then((ZegoMediaPlayerLoadResourceResult result) => {
                debugPrint(result.errorCode.toString()),
                if (result.errorCode == 0)
                  {
                    mediaPlayer!.start(),
                    setEventHandler(),
                  }
                else
                  {}
              });
    }
  }

  listnerEventHandler() async {
    ZegoExpressEngine.onRoomStreamUpdate = onRoomStateUpdated;
    ZegoExpressEngine.onPlayerRecvSEI = onPlayerRecvSEI;
    ZegoExpressEngine.onMediaPlayerRenderingProgress =
        onMediaPlayerRenderingProgress;
  }

  setEventHandler() async {
    setState(() {
      playing = true;
    });

    ZegoExpressEngine.onMediaPlayerPlayingProgress =
        (mediaPlayer, millisecond) {
      sendSEIMessage(millisecond);
      setState(() {
        sliderProgress = millisecond.toDouble();
        playProgress = millisecond;
      });
    };

    ZegoExpressEngine.onMediaPlayerStateUpdate =
        (mediaPlayer, state, errorCode) {
      setState(() {
        playing = state == ZegoMediaPlayerState.Playing;
      });
    };
    String streamID = "music" + widget.roomID;

    await ZegoExpressEngine.instance.startPublishingStream(streamID);
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
    // _startSinging();
    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      player.getCurrentProgress().then((currentPosition) {
        Duration currentDuration = Duration(milliseconds: currentPosition);

        var previousTimestamps =
            lyricsTimingMap.keys.where((k) => k as Duration <= currentDuration);

        if (previousTimestamps.isNotEmpty) {
          Duration latestTimestamp = previousTimestamps
              .reduce((Duration a, Duration b) => a > b ? a : b);

          setState(() {
            _currentLyrics = lyricsTimingMap[latestTimestamp] ?? '';
          });
        }
      });
    });
  }

  void startListenEvent() {
    // Callback for updates on the status of other users in the room.
    // Users can only receive callbacks when the isUserStatusNotify property of ZegoRoomConfig is set to `true` when logging in to the room (loginRoom).
    ZegoExpressEngine.onRoomUserUpdate =
        (roomID, updateType, List<ZegoUser> userList) {
      debugPrint(
          'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
    };
    // Callback for updates on the status of the streams in the room.
    ZegoExpressEngine.onRoomStreamUpdate =
        (roomID, updateType, List<ZegoStream> streamList, extendedData) {
      debugPrint(
          'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          startPlayStream(stream.streamID);
        }
      } else {
        for (final stream in streamList) {
          stopPlayStream(stream.streamID);
        }
      }
    };
    // Callback for updates on the current user's room connection status.
    ZegoExpressEngine.onRoomStateUpdate =
        (roomID, state, errorCode, extendedData) {
      debugPrint(
          'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };

    // Callback for updates on the current user's stream publishing changes.
    ZegoExpressEngine.onPublisherStateUpdate =
        (streamID, state, errorCode, extendedData) {
      debugPrint(
          'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };
  }

  void stopListenEvent() {
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
  }

  Future<void> startPreview() async {
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      localViewID = viewID;
      ZegoCanvas previewCanvas =
          ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
    }).then((canvasViewWidget) {
      setState(() => localView = canvasViewWidget);
    });
  }

  Future<void> stopPreview() async {
    ZegoExpressEngine.instance.stopPreview();
    if (localViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
      setState(() {
        localViewID = null;
        localView = null;
      });
    }
  }

  void onRoomStateUpdated(String roomID, ZegoUpdateType updateType,
      List<ZegoStream> streamList, extendedData) {
    debugPrint('AAAAAAAAAAAAAAADDDDDDDDDDDDDDDFFFFFFFFFFFFFGGGGGG');
    String streamID = "music" + widget.roomID;
    ZegoStream? stream =
        streamList.where((element) => element.streamID == streamID).first;

    if (stream.streamID.isNotEmpty) {
      String playStreamID = stream.streamID;
      if (updateType == ZegoUpdateType.Add) {
        ZegoExpressEngine.instance
            .setPlayStreamBufferIntervalRange(playStreamID, 500, 4000);
        ZegoExpressEngine.instance.startPlayingStream(playStreamID);

        setState(() {
          playing = true;
        });
      } else {
        ZegoExpressEngine.instance.stopPlayingStream(playStreamID);
      }
    }
  }

  void onPlayerRecvSEI(String streamID, Uint8List data) {
    String dataString = utf8.decode(data);

    // try {
    Map<String, dynamic> jsonObject = jsonDecode(dataString);
    String KEY_PROGRESS_IN_MS = "KEY_PROGRESS_IN_MS";
    int progress = jsonObject[KEY_PROGRESS_IN_MS];
    debugPrint('on seat opened');

    setState(() {
      AudiencEsliderProgress = progress.toDouble();
      playProgress = progress;
    });
    // } catch (e) {
    //   print(e);
    // }
  }

  void onMediaPlayerRenderingProgress(ZegoMediaPlayer mediaPlayer, int data) {
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa');
    setState(() {
      AudiencEsliderProgress = data.toDouble();
      playProgress = data;
    });
    // String dataString = utf8.decode(data);

    // // try {
    // Map<String, dynamic> jsonObject = jsonDecode(dataString);
    // String KEY_PROGRESS_IN_MS = "KEY_PROGRESS_IN_MS";
    // int progress = jsonObject[KEY_PROGRESS_IN_MS];
    // debugPrint('on seat opened');

    // setState(() {
    //   AudiencEsliderProgress = progress.toDouble();
    //   playProgress = progress;
    // });
    // } catch (e) {
    //   print(e);
    // }
  }

  void sendSEIMessage(int millisecond) {
    try {
      Map<String, dynamic> localMusicProcessStatusJsonObject = {
        'KEY_PROGRESS_IN_MS': millisecond,
      };
      String jsonData = jsonEncode(localMusicProcessStatusJsonObject);
      Uint8List data = utf8.encode(jsonData);
      ZegoExpressEngine.instance.sendSEI(
        data,
        data.length,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> startPublish() async {
    // After calling the `loginRoom` method, call this method to publish streams.
    // The StreamID must be unique in the room.
    String streamID = '${widget.roomID}_${localUserID}_call';
    return ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  Future<void> stopPublish() async {
    return ZegoExpressEngine.instance.stopPublishingStream();
  }

  Future<void> startPlayStream(String streamID) async {
    // Start to play streams. Set the view for rendering the remote streams.
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      remoteViewID = viewID;
      ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    }).then((canvasViewWidget) {
      setState(() => remoteView = canvasViewWidget);
    });
  }

  Future<void> stopPlayStream(String streamID) async {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (remoteViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
      setState(() {
        remoteViewID = null;
        remoteView = null;
      });
    }
  }

  initAudience() async {
    await ZegoExpressEngine.createEngineWithProfile(profile);
  }

  @override
  void initState() {
    listnerEventHandler();

    super.initState();
  }

  @override
  void dispose() {
    stopListenEvent();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ZegoUIKitPrebuiltLiveAudioRoom(
            appID:
                653933933, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
            appSign:
                "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40", // nput your AppSign*/,
            userID: localUserID,
            userName: 'user_$localUserID',
            roomID: widget.roomID,
            controller: liveController,
            config: (widget.isHost
                ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
              ..inRoomMessageConfig = ZegoInRoomMessageConfig()
              ..takeSeatIndexWhenJoining =
                  widget.isHost ? getHostSeatIndex() : -1
              ..hostSeatIndexes = getLockSeatIndex()
              ..layoutConfig = getLayoutConfig()
              ..seatConfig = getSeatConfig()
              ..background = background()
              ..foreground = foreground(constraints)
              ..topMenuBarConfig.buttons = [
                ZegoMenuBarButtonName.minimizingButton
              ]
              ..backgroundMediaConfig = ZegoBackgroundMediaConfig()
              ..userAvatarUrl = 'https://robohash.org/$localUserID.png'
              ..onUserCountOrPropertyChanged = (List<ZegoUIKitUser> users) {
                debugPrint(
                    'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}');
              }
              ..onSeatClosed = () {
                debugPrint('on seat closed');
              }
              ..onSeatsOpened = () {
                debugPrint('on seat opened');
              }
              ..onSeatsChanged = (
                Map<int, ZegoUIKitUser> takenSeats,
                List<int> untakenSeats,
              ) {
                debugPrint(
                    'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats');
              }
              ..onSeatTakingRequested = (ZegoUIKitUser audience) {
                debugPrint('on seat taking requested, audience:$audience');
              }
              ..onSeatTakingRequestCanceled = (ZegoUIKitUser audience) {
                debugPrint(
                    'on seat taking request canceled, audience:$audience');
              }
              ..onInviteAudienceToTakeSeatFailed = () {
                debugPrint('on invite audience to take seat failed');
              }
              ..onSeatTakingInviteRejected = () {
                debugPrint('on seat taking invite rejected');
              }
              ..onSeatTakingRequestFailed = () {
                debugPrint('on seat taking request failed');
              }
              ..onSeatTakingRequestRejected = () {
                debugPrint('on seat taking request rejected');
              }
              ..onHostSeatTakingInviteSent = () {
                debugPrint('on host seat taking invite sent');
              }

              /// WARNING: will override prebuilt logic
              // ..onSeatClicked = (int index, ZegoUIKitUser? user) {
              //   debugPrint(
              //       'on seat clicked, index:$index, user:${user.toString()}');
              // }

              /// WARNING: will override prebuilt logic
              ..onMemberListMoreButtonPressed = onMemberListMoreButtonPressed,
          );
        },
      ),
    );
  }

  Stack buildReaderWidget() {
    return Stack(
      children: [
        LyricsReader(
          padding: EdgeInsets.symmetric(horizontal: 0),
          model: lyricModel,
          position: playProgress,
          lyricUi: lyricUI,
          playing: playing,
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.5),
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics",
              style: lyricUI.getOtherMainTextStyle(),
            ),
          ),
        )
      ],
    );
  }

  Stack buildAudienceReaderWidget() {
    return Stack(
      children: [
        LyricsReader(
          padding: EdgeInsets.symmetric(horizontal: 0),
          model: lyricModel,
          position: AudienceplayProgress,
          lyricUi: lyricUI,
          playing: playing,
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.5),
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics",
              style: lyricUI.getOtherMainTextStyle(),
            ),
          ),
        )
      ],
    );
  }

  Widget foreground(BoxConstraints constraints) {
    return Container();
    // return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    //   MaterialButton(
    //     onPressed: () {
    //       playSong();
    //     },
    //     child: Text('Play'),
    //   ),
    //   // widget.isHost ? buildReaderWidget() : buildAudienceReaderWidget()
    // ]);
    // return Positioned(
    //     top: 290,
    //     right: 10,
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           width: MediaQuery.of(context).size.width,
    //           child: Text(
    //             _currentLyrics,
    //             style: TextStyle(
    //                 fontSize: 24.0,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.black),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         MaterialButton(
    //             child: Text(
    //               'STOP',
    //               style: TextStyle(color: Colors.white, fontSize: 24),
    //             ),
    //             onPressed: () async {
    //               await ZegoExpressEngine.instance
    //                   .destroyMediaPlayer(mediaPlayer!)
    //                   .then((value) => null);
    //               setState(() {});
    //             })
    //       ],
    //     ));
    // } else {
    //   return Container();
    // }

    // return advanceMediaPlayer(
    //   constraints: constraints,
    //   canControl: widget.isHost,
    // );
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('assets/images/background.jpg').image,
            ),
          ),
        ),
        const Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Live Audio Room',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            'ID: ${widget.roomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff606060),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  ZegoLiveAudioRoomSeatConfig getSeatConfig() {
    if (widget.layoutMode == LayoutMode.hostTopCenter) {
      return ZegoLiveAudioRoomSeatConfig(
        backgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return Container(color: Colors.grey);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
        // avatarBuilder: avatarBuilder,
        );
  }

  Widget avatarBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return CircleAvatar(
      maxRadius: size.width,
      backgroundImage: Image.asset(
              "assets/avatars/avatar_${((int.tryParse(user?.id ?? "") ?? 0) % 6).toString()}.png")
          .image,
    );
  }

  int getHostSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  List<int> getLockSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return [4];
    }

    return [0];
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
    final config = ZegoLiveAudioRoomLayoutConfig();
    switch (widget.layoutMode) {
      case LayoutMode.defaultLayout:
        break;
      case LayoutMode.full:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.hostTopCenter:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
          ),
        ];
        break;
      case LayoutMode.hostCenter:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.fourPeoples:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
    }
    return config;
  }

  void onMemberListMoreButtonPressed(ZegoUIKitUser user) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        const textStyle = TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
        final listMenu = liveController.localHasHostPermissions
            ? [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();

                    ZegoUIKit().removeUserFromRoom(
                      [user.id],
                    ).then((result) {
                      debugPrint('kick out result:$result');
                    });
                  },
                  child: Text(
                    'Kick Out ${user.name}',
                    style: textStyle,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();

                    liveController
                        ?.inviteAudienceToTakeSeat(user.id)
                        .then((result) {
                      debugPrint('invite audience to take seat result:$result');
                    });
                  },
                  child: Text(
                    'Invite ${user.name} to take seat',
                    style: textStyle,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: textStyle,
                  ),
                ),
              ]
            : [];
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listMenu.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 60,
                  child: Center(child: listMenu[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
