// import 'package:flutter/material.dart';
// import 'package:star/constant.dart';
// import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

// class AudioRoomScreen extends StatefulWidget {
//   final String roomID;
//   final bool isHost;
//   final LayoutMode layoutMode;
//   const AudioRoomScreen({
//     Key? key,
//     required this.roomID,
//     this.layoutMode = LayoutMode.defaultLayout,
//     this.isHost = false,
//   }) : super(key: key);

//   @override
//   State<AudioRoomScreen> createState() => _AudioRoomScreenState();
// }

// class _AudioRoomScreenState extends State<AudioRoomScreen> {
//   final liveController = ZegoLiveAudioRoomController();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return ZegoUIKitPrebuiltLiveAudioRoom(
//             appID:
//                 653933933, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//             appSign:
//                 "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40", // put your AppSign*/,
//             userID: localUserID,
//             userName: 'user_$localUserID',
//             roomID: widget.roomID,
//             controller: liveController,
//             config: (widget.isHost
//                 ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
//                 : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
//               ..takeSeatIndexWhenJoining =
//                   widget.isHost ? getHostSeatIndex() : -1
//               ..hostSeatIndexes = getLockSeatIndex()
//               ..layoutConfig = getLayoutConfig()
//               ..seatConfig = getSeatConfig()
//               ..background = background()
//               ..foreground = foreground(constraints)
//               ..topMenuBarConfig.buttons = [
//                 ZegoMenuBarButtonName.minimizingButton
//               ]
//               ..userAvatarUrl = 'https://robohash.org/$localUserID.png'
//               ..onUserCountOrPropertyChanged = (List<ZegoUIKitUser> users) {
//                 debugPrint(
//                     'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}');
//               }
//               ..onSeatClosed = () {
//                 debugPrint('on seat closed');
//               }
//               ..onSeatsOpened = () {
//                 debugPrint('on seat opened');
//               }
//               ..onSeatsChanged = (
//                 Map<int, ZegoUIKitUser> takenSeats,
//                 List<int> untakenSeats,
//               ) {
//                 debugPrint(
//                     'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats');
//               }
//               ..onSeatTakingRequested = (ZegoUIKitUser audience) {
//                 debugPrint('on seat taking requested, audience:$audience');
//               }
//               ..onSeatTakingRequestCanceled = (ZegoUIKitUser audience) {
//                 debugPrint(
//                     'on seat taking request canceled, audience:$audience');
//               }
//               ..onInviteAudienceToTakeSeatFailed = () {
//                 debugPrint('on invite audience to take seat failed');
//               }
//               ..onSeatTakingInviteRejected = () {
//                 debugPrint('on seat taking invite rejected');
//               }
//               ..onSeatTakingRequestFailed = () {
//                 debugPrint('on seat taking request failed');
//               }
//               ..onSeatTakingRequestRejected = () {
//                 debugPrint('on seat taking request rejected');
//               }
//               ..onHostSeatTakingInviteSent = () {
//                 debugPrint('on host seat taking invite sent');
//               }

//               /// WARNING: will override prebuilt logic
//               // ..onSeatClicked = (int index, ZegoUIKitUser? user) {
//               //   debugPrint(
//               //       'on seat clicked, index:$index, user:${user.toString()}');
//               // }

//               /// WARNING: will override prebuilt logic
//               ..onMemberListMoreButtonPressed = onMemberListMoreButtonPressed,
//           );
//         },
//       ),
//     );
//   }
// }
