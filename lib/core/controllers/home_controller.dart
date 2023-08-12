import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/character.dart';
import '../models/comic.dart';
import '../repositorys/marvel_repository.dart';

class HomeController extends ControllerMVC {
  factory HomeController([StateMVC? state]) =>
      _this ??= HomeController._(state);
  HomeController._(StateMVC? state)
      : scaffoldKey = GlobalKey<ScaffoldState>(),
        super(state);

  static HomeController? _this;

  List<Character> characters = <Character>[];
  List<Character> allCharacters = <Character>[];
  List<Comic> allComics = <Comic>[];
  List<Comic> spidermanComic = <Comic>[];
  List<Comic> xmenComic = <Comic>[];
  List<Comic> thorComic = <Comic>[];
  List<Comic> comics = <Comic>[];
  ScrollController scrollController = ScrollController();
  ScrollController scrollHomeController = ScrollController();
  ScrollController scrollComicController = ScrollController();
  ScrollController scrollCharacterController = ScrollController();
  TextEditingController editTextController = TextEditingController();
  FocusNode focusController = FocusNode();
  String? searchTerm;
  final debouncer = Debouncer();
  GlobalKey<ScaffoldState> scaffoldKey;
  bool isLoading = false;
  int page = 0;
  int offset = 0;

  void searchCharacter(String filter) {
    debouncer.execute(() {
      if (filter == '') {
        searchTerm = null;
        refresh();
        listenForCharacters();
      } else {
        searchCharacters(filter);
      }
      setState(() {});
    });
  }

  void initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        listenForCharacters();
      }
    });
  }

  void initScrollCharacterController() {
    scrollCharacterController.addListener(() {
      if (scrollCharacterController.position.pixels ==
              scrollCharacterController.position.maxScrollExtent &&
          !isLoading) {
        listenForCharacters();
      }
    });
  }

  void searchCharacters([String? searchTerms]) {
    refresh();
    searchTerm = searchTerms;
    listenForCharacters();
  }

  void listenPopularComics(int characterId) async {
    comics = await getPopularComics(characterId);
    setState(() {});
  }

  void listenCreatorPopularComics(int creatorId) async {
    comics = await getCreatorPopularComics(creatorId);
    setState(() {});
  }

  void listenForCharacters() async {
    setState(() {
      isLoading = true;
    });
    page++;
    allCharacters = await getCharacters(
      page: page,
      offset: offset,
      searchTerm: searchTerm,
    );
    setState(() {
      characters.addAll(allCharacters);
      isLoading = false;
    });
  }

  void listenForComics() async {
    allComics = await getComics();
    setState(() {});
  }

  void listenSpidermanForComics({String? searchName}) async {
    spidermanComic = await getAllWithOutComics(searchName: searchName);
    setState(() {});
  }

  void listenXmenForComics({String? searchName}) async {
    xmenComic = await getAllWithOutComics(searchName: searchName);
    setState(() {});
  }

  void listenThorForComics({String? searchName}) async {
    thorComic = await getAllWithOutComics(searchName: searchName);
    setState(() {});
  }

  Future<void> cleanTextEditing() async {
    editTextController.clear();
    searchTerm = null;
    refresh();
    listenForCharacters();
  }

  @override
  Future<void> refresh({bool refreshComics = false}) async {
    page = 0;
    offset = 0;
    characters.clear();
    if (refreshComics) {
      listenForCharacters();
    }
  }
}

class Debouncer {
  Timer? timer;

  void execute(VoidCallback action) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), action);
  }
}
