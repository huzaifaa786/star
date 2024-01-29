// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:star/widgets/solo_singing_widgets.dart/topbar.dart';

class SoloSingingUI extends StatefulWidget {
  const SoloSingingUI({super.key});

  @override
  State<SoloSingingUI> createState() => _SoloSingingUIState();
}

class _SoloSingingUIState extends State<SoloSingingUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 115, 39, 163),
                Color(0xff631b90),
                Color.fromARGB(255, 97, 17, 155),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SoloSingingUITopBar(
                  image: "https://dummyimage.com/150x150/000000/fff",
                  name: 'Abdur Rehman Maken',
                  audience: '1k',
                  onBackTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         CachedNetworkImage(
                //           imageUrl: "https://dummyimage.com/150x150/000000/fff",
                //           fit: BoxFit.cover,
                //           imageBuilder: (context, imageProvider) => Container(
                //             width: 55.0,
                //             height: 55.0,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               image: DecorationImage(
                //                   image: imageProvider, fit: BoxFit.cover),
                //             ),
                //           ),
                //           placeholder: (context, url) =>
                //               Center(child: CircularProgressIndicator()),
                //           errorWidget: (context, url, error) =>
                //               Icon(Icons.error),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(left: 8, right: 8),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               SizedBox(
                //                 width: MediaQuery.of(context).size.width * 0.5,
                //                 child: Text(
                //                   'Abdur Rehman Maken',
                //                   style: TextStyle(
                //                       color: Colors.grey[200],
                //                       fontWeight: FontWeight.w700,
                //                       fontSize: 16),
                //                 ),
                //               ),
                //               Text('is Singing',
                //                   style: TextStyle(
                //                       color: Colors.grey[200], fontSize: 12))
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Container(
                //           height: 35,
                //           width: 50,
                //           decoration: BoxDecoration(
                //               color: Colors.deepPurple,
                //               borderRadius: BorderRadius.circular(30)),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(Icons.person,
                //                   color: Colors.grey[200], size: 16),
                //               Text('1k',
                //                   style: TextStyle(
                //                       color: Colors.grey[200], fontSize: 12)),
                //             ],
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(left: 8),
                //           child: InkWell(
                //             onTap: () {
                //               Navigator.pop(context);
                //             },
                //             child: Icon(Icons.close_sharp,
                //                 color: Colors.grey[200], size: 24),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
