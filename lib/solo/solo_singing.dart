import 'dart:math';

import 'package:flutter/material.dart';
import 'package:star/constant.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class SoloSinging extends StatefulWidget {
  const SoloSinging({super.key});

  @override
  State<SoloSinging> createState() => _SoloSingingState();
}

class _SoloSingingState extends State<SoloSinging> {
  String? userID;
  String? userName;
  ZegoUser? user;
  bool isHost = true;
  ZegoRoomConfig? roomConfig;
  final engine = ZegoExpressEngine.instance;
  final roomID = Random().nextInt(10000).toString();
  final token = Random().nextInt(1000000).toString();
  Future<void> createEngineWithProfile() async {
    ZegoEngineProfile profile = ZegoEngineProfile(
      653933933,
      ZegoScenario.Karaoke,
      appSign:
          "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
    );
    return await ZegoExpressEngine.createEngineWithProfile(profile);
  }

  loginRoom() async {
    userID = localUserID;
    userName = localUserID.toString();

    user = ZegoUser(userID!, userName!);
    roomConfig = ZegoRoomConfig(5, true, token);

    // engine.loginRoom(roomID, user!, config: roomConfig);
  }

  @override
  void initState() {
    createEngineWithProfile();
    loginRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return ZegoUIKitPrebuiltLiveStreaming(
          appID: 653933933 /*input your AppID*/,
          appSign:
              "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
          userID: userID!,
          userName: userID!,
          liveID: roomID,
          config: isHost
              ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
              : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
            ..turnOnCameraWhenJoining = false
            ..bottomMenuBarConfig.hostButtons = [
              ZegoMenuBarButtonName.toggleMicrophoneButton
            ]
            ..background = background(constraints),
          events: ZegoUIKitPrebuiltLiveStreamingEvents(
              hostEvents: ZegoUIKitPrebuiltLiveStreamingHostEvents(
                
              ),
              audienceEvents: ZegoUIKitPrebuiltLiveStreamingAudienceEvents(),
              pkEvents: ZegoUIKitPrebuiltLiveStreamingPKV2Events()),
          controller: ZegoUIKitPrebuiltLiveStreamingController(),
        );
      }),
    );
  }

  Widget background(constraints) {
    /// how to replace background view
    const padding = 20;
    final playerSize =
        Size(constraints.maxWidth - padding * 2, constraints.maxWidth * 9 / 16);
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
            'ID: ${roomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff606060),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Positioned(
        //     top: 10 + 40,
        //     left: 20,
        //     child: advanceMediaPlayer(
        //         canControl: true, constraints: constraints, url: ''))
      ],
    );
  }
}

// Widget simpleMediaPlayer({
//   required bool canControl,
//   required ZegoMediaPlayer? liveController,
//   required text,
// }) {

//   return canControl
//       ? Positioned(
//           bottom: 60,
//           right: 10,
//           child: Container(
//             color: Colors.white,
//             height: 200,
//             child: SingleChildScrollView(
//               child: ValueListenableBuilder<ZegoUIKitMediaPlayState>(
//                 valueListenable: ZegoUIKit().getMediaPlayStateNotifier(),
//                 builder: (context, playState, _) {
//                   return Column(
//                     children: [
//                       for (var i = 0; i < text.lyricList.length; i++)
//                         Text(text.lyricList[i].content.toString()),
//                       Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               if (ZegoUIKitMediaPlayState.playing ==
//                                   playState) {
//                                 liveController?.media.pause();
//                               } else if (ZegoUIKitMediaPlayState.pausing ==
//                                   playState) {
//                                 liveController?.media.resume();
//                               } else {
//                                 liveController?.media.pickFile().then((files) {
//                                   if (files.isEmpty) {
//                                     debugPrint('files is empty');
//                                   } else {
//                                     final mediaFile = files.first;
//                                     var targetPathOrURL = mediaFile.path ?? '';
//                                     liveController.loadResource(targetPathOrURL
//                                     );
//                                   }
//                                 });
//                               }
//                             },
//                             child: Icon(
//                               ZegoUIKitMediaPlayState.playing == playState
//                                   ? Icons.pause_circle
//                                   : Icons.play_circle,
//                               color: Colors.black,
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               liveController?.media.stop();
//                             },
//                             child: const Icon(
//                               Icons.stop_circle,
//                               color: Colors.red,
//                             ),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: ZegoUIKit().getMediaMuteNotifier(),
//                             builder: (context, isMute, _) {
//                               return ElevatedButton(
//                                 onPressed: () {
//                                   liveController?.media.muteLocal(!isMute);
//                                 },
//                                 child: Icon(
//                                   isMute ? Icons.volume_off : Icons.volume_up,
//                                   color: Colors.black,
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         )
//       : Container();
// }
