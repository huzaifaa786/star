import 'dart:math';

import 'package:flutter/material.dart';
import 'package:star/constant.dart';
import 'package:star/live_page.dart';
import 'package:star/live_sing_view.dart';
import 'package:star/solo/solo_singing.dart';
import 'package:star/solo_sing_view.dart';

class KaraokeAppHomePage extends StatefulWidget {
  KaraokeAppHomePage({Key? key}) : super(key: key);

  @override
  State<KaraokeAppHomePage> createState() => _KaraokeAppHomePageState();
}

class _KaraokeAppHomePageState extends State<KaraokeAppHomePage> {
  final roomIDTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());
  final userID = Random().nextInt(10000).toString();

  final layoutValueNotifier =
      ValueNotifier<LayoutMode>(LayoutMode.defaultLayout);
  var result;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karaoke App'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Karaoke App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Image.asset(
              'assets/images/karaoke_logo.jpeg',
              height: 200,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                const Text('RoomID:'),
                const SizedBox(width: 10, height: 20),
                Expanded(
                  child: TextField(
                    controller: roomIDTextCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Please Input RoomID'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                jumpToLivePage(
                  context,
                  roomID: roomIDTextCtrl.text.trim(),
                  isHost: true,
                  userID: userID,
                );
              },
              child: Text('Start Singing'),
            ),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () {
                jumpToLivePage(context,
                    roomID: roomIDTextCtrl.text.trim(),
                    isHost: false,
                    userID: userID);
              },
              child: Text('Browse Songs'),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(
    BuildContext context, {
    required String roomID,
    required bool isHost,
    required String userID,
  }) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LivePage(
                  roomID: roomID,
                  // userID: userID,
                  isHost: isHost,
                )));
  }
}
