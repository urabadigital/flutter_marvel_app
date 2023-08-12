import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/character.dart';
import '../../views/character/character_details_view.dart';

class CharacterGrid extends StatelessWidget {
  const CharacterGrid({
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Hero(
                tag: heroTag + character.id.toString(),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${character.thumbnail?.path}.${character.thumbnail?.extension}",
                    placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                            const Center(child: CupertinoActivityIndicator())),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  character.name ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
