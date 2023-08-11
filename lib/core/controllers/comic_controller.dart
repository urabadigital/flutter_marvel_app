import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/character.dart';
import '../models/comic.dart';
import '../repositorys/marvel_repository.dart';

class ComicController extends ControllerMVC {
  factory ComicController([StateMVC? state]) =>
      _this ??= ComicController._(state);
  ComicController._(StateMVC? state)
      : scaffoldKey = GlobalKey<ScaffoldState>(),
        super(state);

  static ComicController? _this;

  List<Comic> allComics = <Comic>[];
  List<Comic> popularComics = <Comic>[];
  List<Comic> comics = <Comic>[];
  List<Character> characters = <Character>[];
  List<Creator> creators = <Creator>[];

  ScrollController scrollComicController = ScrollController();
  TextEditingController editTextController = TextEditingController();
  String? searchTerm;
  final debouncer = Debouncer();
  GlobalKey<ScaffoldState> scaffoldKey;
  bool isLoading = false;
  int page = 0;
  int offset = 0;

  void searchComic(String filter) {
    debouncer.execute(() {
      if (filter == '') {
        listenForComics();
      } else {
        searchComics(filter);
      }
      setState(() {});
    });
  }

  void initScrollController() {
    scrollComicController.addListener(() {
      if (scrollComicController.position.pixels ==
              scrollComicController.position.maxScrollExtent &&
          !isLoading) {
        listenForComics();
      }
    });
  }

  void searchComics([String? searchTerms]) {
    refresh();
    searchTerm = searchTerms;
    listenForComics();
  }

  void listenPopularComics(int characterId) async {
    comics = await getPopularComics(characterId);
    setState(() {});
  }

  void listenCharactersComics(int characterId) async {
    characters = await getCharacterComics(characterId);
    setState(() {});
  }

  void listenCreatorsComics(int creatorId) async {
    creators = await getCreatorComics(creatorId);
    setState(() {});
  }

  void listenAllWithOutComics({String? searchName}) async {
    popularComics =
        await getAllWithOutComics(limit: 100, searchName: searchName);
    setState(() {});
  }

  void listenForComics() async {
    setState(() {
      isLoading = true;
    });
    page++;
    comics = await getComics(
      page: page,
      offset: offset,
      searchTerm: searchTerm,
    );
    setState(() {
      allComics.addAll(comics);
      isLoading = false;
    });
  }

  Future<void> cleanTextEditing() async {
    editTextController.clear();
    searchTerm = null;
    refresh();
    listenForComics();
  }

  @override
  void refresh() {
    page = 0;
    offset = 0;
    allComics.clear();
  }
}

class Debouncer {
  Timer? timer;

  void execute(VoidCallback action) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), action);
  }
}
