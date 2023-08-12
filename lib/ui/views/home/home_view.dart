import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../core/controllers/home_controller.dart';
import '../../../core/providers/theme_changer.dart';
import '../../widgets/comic/comics_carrousel.dart';
import '../../widgets/home/all_comic_carrousel.dart';
import '../character/search_view.dart';
import '../comic/all_comic_view.dart';
import '../comic/all_without_comic_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends StateMVC<MyHomePage> {
  MyHomePageState() : super(HomeController()) {
    _con = controller as HomeController;
  }
  late HomeController _con;

  @override
  void initState() {
    super.initState();
    _con.listenForComics();
    _con.listenSpidermanForComics(searchName: 'Spider-Man');
    _con.listenXmenForComics(searchName: 'X-Men');
    _con.listenThorForComics(searchName: 'Thor');
  }

  @override
  Widget build(BuildContext context) {
    bool isWhite = ThemeChanger.of(context).myChangeNotifier.isWhite;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Marvel Comics',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () {
                      ThemeChanger.of(context).myChangeNotifier.updateTheme();
                    },
                    icon: Icon(
                      isWhite ? Icons.nights_stay : Icons.sunny,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(SearchModal());
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: Icon(Icons.search,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        'Search character',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (_con.allComics.isEmpty)
                const Expanded(
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                )
              else
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: _con.scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                title: Text(
                                  'All Comics',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllComicsView(),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              AllComicCarrouselWidget(
                                comics: _con.allComics,
                                heroTag: 'all_comic',
                              ),
                              const SizedBox(height: 5),
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                title: Text(
                                  'New Spider Man Comics',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllWithOutComicsView(
                                              title: 'Spider-Man',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ComicCarrouselWidget(
                                comics: _con.spidermanComic,
                                heroTag: 'spiderman_comic',
                              ),
                              const SizedBox(height: 5),
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                title: Text(
                                  'Popular  X-Men Comics',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllWithOutComicsView(
                                              title: 'X-Men',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ComicCarrouselWidget(
                                comics: _con.xmenComic,
                                heroTag: 'xmen_comic',
                              ),
                              const SizedBox(height: 5),
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                title: Text(
                                  'Popular Thor Comics',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllWithOutComicsView(
                                              title: 'Thor',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ComicCarrouselWidget(
                                comics: _con.thorComic,
                                heroTag: 'thor_comic',
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
