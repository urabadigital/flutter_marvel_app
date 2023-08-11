import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/comic.dart';
import '../../views/comic/comic_details_view.dart';

class ComicCarrouselWidget extends StatelessWidget {
  final List<Comic> comics;
  final String? heroTag;

  const ComicCarrouselWidget({
    super.key,
    required this.comics,
    this.heroTag,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        itemCount: comics.length,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final comic = comics[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor,
                    blurRadius: .7,
                  ),
                ],
                color: Theme.of(context).hintColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(8),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ComicDetailsView(
                            comic: comic,
                            heroTag: heroTag ?? 'detail',
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: '$heroTag${comic.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: SizedBox(
                          height: 150,
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: Text(
                      comic.title ?? '',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
