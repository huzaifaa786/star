// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SoloSingingUITopBar extends StatelessWidget {
  const SoloSingingUITopBar(
      {super.key, this.image, this.name, this.audience, this.onBackTap});
  final String? image;
  final String? name;
  final String? audience;
  final onBackTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: image!,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      '$name',
                      style: TextStyle(
                          color: Colors.grey[200],
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                  Text('is Singing',
                      style: TextStyle(color: Colors.grey[200], fontSize: 12))
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 35,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Colors.grey[200], size: 16),
                  Text('$audience',
                      style: TextStyle(color: Colors.grey[200], fontSize: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: onBackTap,
                child:
                    Icon(Icons.close_sharp, color: Colors.grey[200], size: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
