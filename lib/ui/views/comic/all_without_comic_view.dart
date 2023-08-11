import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../core/controllers/comic_controller.dart';
import 'comic_details_view.dart';

class AllWithOutComicsView extends StatefulWidget {
  const AllWithOutComicsView({super.key, required this.title});

  final String title;

  @override
  AllWithOutComicsViewState createState() => AllWithOutComicsViewState();
}

class AllWithOutComicsViewState extends StateMVC<AllWithOutComicsView> {
  AllWithOutComicsViewState() : super(ComicController()) {
    _con = controller as ComicController;
  }
  late ComicController _con;

  @override
  void initState() {
    super.initState();
    _con.listenAllWithOutComics(searchName: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: _con.popularComics.isEmpty
              ? const Expanded(
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 500
                                        ? 4
                                        : 2,
                                childAspectRatio: (9 / 16),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (_, i) {
                                  final pupularComic = _con.popularComics[i];
                                  return Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ComicDetailsView(
                                                comic: pupularComic,
                                                heroTag: 'comic_ detail',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          foregroundDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                blurRadius: .7,
                                              ),
                                            ],
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                '${pupularComic.thumbnail?.path}.${pupularComic.thumbnail?.extension}',
                                              ),
                                            ),
                                          ),
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              pupularComic.title ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                childCount: _con.popularComics.length,
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
