import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:meno/details_screen.dart';
import 'package:meno/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meno',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        indicatorColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        indicatorColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final rnd = Random();
  late List<int> extents;
  int crossAxisCount = 4;
  late TabController _tabController;
  int _selectedTabIndex = 1;
  final ScrollController primaryGridViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    extents = List<int>.generate(10000, (int index) => rnd.nextInt(5) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.forest_rounded),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 36,
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                unselectedLabelColor: Colors.grey[200],
                labelColor: Colors.white,
                indicatorColor: Colors.greenAccent,
                isScrollable: true,
                indicatorWeight: 1.5,
                enableFeedback: false,
                indicatorSize: TabBarIndicatorSize.label,
                onTap: (value) {
                  if (value == _selectedTabIndex) {
                    primaryGridViewController.animateTo(
                      0,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeIn,
                    );
                    return;
                  }
                  setState(() => _selectedTabIndex = value);
                },
                tabs: const [
                  Tab(text: 'Follow'),
                  Tab(text: 'Explore'),
                  Tab(text: 'Nearby'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: const SearchScreen(),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          EasyRefresh(
            header: const CupertinoHeader(),
            footer: const CupertinoFooter(),
            onLoad: () {},
            onRefresh: () {},
            child: MasonryGridView.count(
              padding: const EdgeInsets.symmetric(vertical: 10),
              crossAxisCount: 2,
              controller: primaryGridViewController,
              cacheExtent: 1000,
              mainAxisSpacing: 10,
              crossAxisSpacing: 6,
              itemCount: extents.length,
              itemBuilder: (context, index) {
                final height = extents[index] * 100;
                return ImageTile(
                  index: index,
                  width: 500,
                  height: height,
                );
              },
            ),
          ),
          Visibility(
            visible: _selectedTabIndex == 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                height: 36,
                width: 160,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_circle_up_rounded,
                      color: Colors.black,
                      size: 18,
                    ),
                    const Gap(5),
                    Text(
                      'New Posts',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
    required this.width,
    required this.height,
    this.textStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.showProfile = true,
  }) : super(key: key);

  final int index;
  final int width;
  final int height;
  final TextStyle textStyle;
  final bool showProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            settings: RouteSettings(name: "Image", arguments: {
              'index': index,
              'width': width,
              'height': height,
            }),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: const DetailScreen(),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: 'image$index',
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://picsum.photos/$height/$width?random=$index',
                  placeholder: (context, url) {
                    return const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  width: width.toDouble(),
                  height: height.toDouble(),
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(5),
              Padding(
                padding: const EdgeInsets.all(5),
                child: AutoSizeText(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nis nisl euismod, nisl',
                  style: textStyle,
                  maxLines: 2,
                  minFontSize: 13,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Gap(5),
              Visibility.maintain(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Gap(5),
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: CachedNetworkImageProvider(
                        'https://picsum.photos/100?random=$index',
                      ),
                    ),
                    const Gap(3),
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 15,
                    ),
                    const Gap(3),
                    Text(
                      Random().nextInt(1000).toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
