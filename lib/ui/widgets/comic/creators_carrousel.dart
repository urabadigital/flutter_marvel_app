import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/models/comic.dart';
import '../../views/creator/creator_details_view.dart';

class CreatorCarrouselWidget extends StatelessWidget {
  final List<Creator> creators;
  final String heroTag;

  const CreatorCarrouselWidget({
    super.key,
    required this.creators,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: creators.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int i) {
            final creator = creators[i];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatorDetailsView(
                      creator: creator,
                      heroTag: heroTag,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          blurRadius: .7,
                        ),
                      ],
                      color: Theme.of(context).hintColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(8),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: heroTag + creator.id.toString(),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 220,
                              imageUrl:
                                  '${creator.thumbnail?.path}.${creator.thumbnail?.extension}',
                              placeholder: (context, url) => Container(
                                  color: Colors.grey,
                                  height: 220,
                                  child: const Center(
                                      child: CupertinoActivityIndicator())),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                creator.fullName?.toUpperCase() ?? '',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
          }),
    );
  }
}
