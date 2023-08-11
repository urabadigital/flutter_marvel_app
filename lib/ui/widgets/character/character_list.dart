import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/character.dart';
import '../../views/character/character_details_view.dart';

class CharacterList extends StatelessWidget {
  const CharacterList({
    super.key,
    required this.heroTag,
    required this.character,
  });

  final String heroTag;
  final Character character;

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                imageUrl:
                    "${character.thumbnail?.path}.${character.thumbnail?.extension}",
                placeholder: (context, url) => Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: CupertinoActivityIndicator())),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    character.name ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    character.description ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.merge(const TextStyle(fontSize: 14)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
