import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../core/controllers/comic_controller.dart';
import 'comic_details_view.dart';

class AllComicsView extends StatefulWidget {
  const AllComicsView({super.key});

  @override
  AllComicsViewState createState() => AllComicsViewState();
}

class AllComicsViewState extends StateMVC<AllComicsView> {
  AllComicsViewState() : super(ComicController()) {
    _con = controller as ComicController;
  }
  late ComicController _con;

  @override
  void initState() {
    super.initState();
    _con.listenForComics();
    _con.initScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'All Comics',
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _con.editTextController,
                      onSubmitted: (val) {
                        _con.searchComic(val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search comic',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        _con.cleanTextEditing();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
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
                    controller: _con.scrollComicController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 500 ? 4 : 2,
                            childAspectRatio: (9 / 16),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              final comic = _con.allComics[i];
                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ComicDetailsView(
                                            comic: comic,
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
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Theme.of(context).primaryColor,
                                            blurRadius: .7,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            '${comic.thumbnail?.path}.${comic.thumbnail?.extension}',
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          comic.title ?? '',
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
                            childCount: _con.allComics.length,
                          ),
                        ),
                      ),
                      if (_con.searchTerm == null && _con.allComics.isNotEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: SpinKitThreeBounce(
                                color: Colors.red,
                                size: 30.0,
                              ),
                            ),
                          ),
                        )
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
