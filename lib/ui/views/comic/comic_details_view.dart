import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/controllers/comic_controller.dart';
import '../../../core/models/comic.dart';
import '../../widgets/character/characters_carrousel.dart';
import '../../widgets/comic/creators_carrousel.dart';
import '../../widgets/image/image_grid.dart';
import '../image/image_view.dart';

class ComicDetailsView extends StatefulWidget {
  const ComicDetailsView({
    super.key,
    required this.heroTag,
    required this.comic,
  });

  final Comic comic;
  final String heroTag;

  @override
  ComicDetailsViewState createState() => ComicDetailsViewState();
}

class ComicDetailsViewState extends StateMVC<ComicDetailsView> {
  ComicDetailsViewState() : super(ComicController()) {
    _con = controller as ComicController;
  }
  late ComicController _con;

  @override
  void initState() {
    super.initState();
    _con.listenCharactersComics(widget.comic.id ?? 0);
    _con.listenCreatorsComics(widget.comic.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Comic',
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Hero(
                      tag: widget.heroTag + widget.comic.id.toString(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${widget.comic.thumbnail?.path}.${widget.comic.thumbnail?.extension}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 20.0,
                      ),
                      child: Text(
                        widget.comic.title ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.comic.description?.isNotEmpty ?? false) ...[
                      Text(widget.comic.description ?? ''),
                      const SizedBox(height: 20),
                    ],
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context).hintColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Format:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.comic.format?.isNotEmpty ?? false
                                    ? '${widget.comic.format}'
                                    : '-',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Pages:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${widget.comic.pageCount}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(.6),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '\$${widget.comic.prices?[0].price?.floor()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: widget.comic.urls
                                  ?.map((type) => Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                              elevation: 0,
                                              textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            onPressed: () async {
                                              final uri =
                                                  Uri.parse(type.url ?? '');
                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(
                                                  uri,
                                                  mode: LaunchMode.externalApplication,
                                                );
                                              }
                                            },
                                            child: Text(
                                              type.type?.toUpperCase() ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ))
                                  .toList() ??
                              <Widget>[],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.comic.images?.isNotEmpty ?? false) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Images",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                    if (widget.comic.images?.isNotEmpty ?? false) ...[
                      PhotoGrid(
                        imageUrls: widget.comic.images ?? [],
                        heroTag: 'image_comic',
                        onImageClicked: (i) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageView(
                                heroTag: 'image_comic',
                                imageIndex: i,
                                imageList: widget.comic.images ?? <Image>[],
                              ),
                            ),
                          );
                        },
                        onExpandClicked: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageView(
                                imageIndex: 3,
                                imageList: widget.comic.images ?? <Image>[],
                              ),
                            ),
                          );
                        },
                        maxImages: 4,
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (_con.characters.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Characters",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      CharacterCarrouselWidget(
                        characters: _con.characters,
                        heroTag: 'character_detail',
                      ),
                    ],
                    if (_con.creators.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Creators",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      CreatorCarrouselWidget(
                        creators: _con.creators,
                        heroTag: 'creator_detail',
                      ),
                      const SizedBox(height: 30)
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
