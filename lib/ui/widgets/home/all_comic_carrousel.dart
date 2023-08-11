import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/comic.dart';
import '../../views/comic/comic_details_view.dart';

class AllComicCarrouselWidget extends StatelessWidget {
  const AllComicCarrouselWidget(
      {super.key, required this.comics, required this.heroTag});

  final List<Comic> comics;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: comics.length,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final comic = comics[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComicDetailsView(
                    comic: comic,
                    heroTag: heroTag,
                  ),
                ),
              );
            },
            child: Container(
              width: 170,
              margin: const EdgeInsets.all(8),
              foregroundDecoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).hintColor.withOpacity(0.05),
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: heroTag + comic.id.toString(),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              '${comic.thumbnail?.path}.${comic.thumbnail?.extension}',
                          placeholder: (context, url) => Container(
                            height: 230,
                            color: Colors.grey,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        comic.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
