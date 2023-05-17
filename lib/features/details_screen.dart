import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meno/features/home/home_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // index from arguments of previous screen
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedIndex = args['index'] as int;
    var itemHeight = args['height'] as int;
    var itemWidth = args['width'] as int;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Gap(5),
            CircleAvatar(
              radius: 14,
              backgroundImage: CachedNetworkImageProvider(
                'https://picsum.photos/100?random=${Random().nextInt(100)}',
              ),
            ),
            const Gap(10),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: ListView(
        children: [
          Expanded(
            child: ImageTile(
              index: selectedIndex,
              width: width.toInt(),
              showProfile: false,
              height: 400,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
