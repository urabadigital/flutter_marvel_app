import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/controllers/home_controller.dart';
import '../../../core/models/character.dart';
import '../../../core/providers/themechanger.dart';
import '../../widgets/comic/comics_carrousel.dart';

class CharacterDetailsView extends StatefulWidget {
  const CharacterDetailsView({
    super.key,
    required this.heroTag,
    required this.character,
  });

  final Character character;
  final String heroTag;

  @override
  CaracterDetailsViewState createState() => CaracterDetailsViewState();
}

class CaracterDetailsViewState extends StateMVC<CharacterDetailsView> {
  CaracterDetailsViewState() : super(HomeController()) {
    _con = controller as HomeController;
  }
  late HomeController _con;

  @override
  void initState() {
    super.initState();
    _con.listenPopularComics(widget.character.id ?? 0);
  }

  @override
  void dispose() {
    super.dispose();
    _con.comics.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool isWhite = ThemeChanger.of(context).myChangeNotifier.isWhite;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Character',
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
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Hero(
                  tag: widget.heroTag + widget.character.id.toString(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${widget.character.thumbnail?.path}.${widget.character.thumbnail?.extension}",
                      placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: CupertinoActivityIndicator())),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.character.name ?? '',
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (widget.character.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 10),
                  Text(widget.character.description ?? ''),
                  const SizedBox(height: 20),
                ],
                Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.character.urls
                              ?.map((type) => Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
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
                                          final uri = Uri.parse(type.url ?? '');
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
                                              color: isWhite
                                                  ? Colors.white
                                                  : Colors.black),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Popular Comics",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (_con.comics.isNotEmpty)
                  ComicCarrouselWidget(
                    comics: _con.comics,
                    heroTag: widget.heroTag,
                  ),
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
