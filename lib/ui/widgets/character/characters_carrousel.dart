import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/character.dart';
import '../../views/character/character_details_view.dart';

class CharacterCarrouselWidget extends StatelessWidget {
  final List<Character> characters;
  final String heroTag;

  const CharacterCarrouselWidget({
    super.key,
    required this.characters,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: characters.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          final character = characters[i];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CharacterDetailsView(
                    character: character,
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
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(8),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: heroTag + character.id.toString(),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 250,
                            imageUrl:
                                '${character.thumbnail?.path}.${character.thumbnail?.extension}',
                            placeholder: (context, url) => Container(
                                color: Colors.grey,
                                height: 250,
                                child: const Center(
                                    child: CupertinoActivityIndicator())),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            character.name?.toUpperCase() ?? '',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (character.description?.isNotEmpty ?? false)
                            Text(
                              character.description ?? '',
                              maxLines: 2,
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
