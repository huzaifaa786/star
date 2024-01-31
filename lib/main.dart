import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:star/MultiSingerKaraoke/login_page.dart';
import 'package:star/constant.dart';
import 'package:star/home_page.dart';
import 'package:star/live_page.dart';
import 'package:star/flutter_lyrics.dart';

import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ZegoUIKit().initLog().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(
        title: "Login Page",
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  /// Users who use the same liveID can join the same live audio room.
  final roomIDTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());
  final layoutValueNotifier =
      ValueNotifier<LayoutMode>(LayoutMode.defaultLayout);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(180, 60),
      foregroundColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.6),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID:$localUserID'),
            const Text('Please test with two or more devices'),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Layout : '),
                  switchDropList<LayoutMode>(
                    layoutValueNotifier,
                    [
                      LayoutMode.defaultLayout,
                      LayoutMode.full,
                      LayoutMode.hostTopCenter,
                      LayoutMode.hostCenter,
                      LayoutMode.fourPeoples,
                    ],
                    (LayoutMode layoutMode) {
                      return Text(layoutMode.text);
                    },
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: roomIDTextCtrl,
              decoration: const InputDecoration(labelText: 'join a live by id'),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                ZegoLiveAudioRoomController();
                if (ZegoLiveAudioRoomController().minimize.isMinimizing) {
                  return;
                }

                jumpToLivePage(
                  context,
                  roomID: roomIDTextCtrl.text.trim(),
                  isHost: true,
                );
              },
              child: const Text('Start a live'),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                if (ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
                    .isMinimizing) {
                  /// when the application is minimized (in a minimized state),
                  /// disable button clicks to prevent multiple PrebuiltAudioRoom components from being created.
                  return;
                }

                jumpToLivePage(
                  context,
                  roomID: roomIDTextCtrl.text.trim(),
                  isHost: false,
                );
              },
              child: const Text('Watch a live'),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String roomID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          roomID: roomID,
          isHost: isHost,
          layoutMode: layoutValueNotifier.value,
        ),
      ),
    );
  }

  Widget switchDropList<T>(
    ValueNotifier<T> notifier,
    List<T> itemValues,
    Widget Function(T value) widgetBuilder,
  ) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: itemValues.map((T itemValue) {
            return DropdownMenuItem(
              value: itemValue,
              child: widgetBuilder(itemValue),
            );
          }).toList(),
          onChanged: (T? newValue) {
            if (newValue != null) {
              notifier.value = newValue;
            }
          },
        );
      },
    );
  }
}
