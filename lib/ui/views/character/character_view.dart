import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../core/controllers/home_controller.dart';
import '../../widgets/character/character_grid.dart';
import '../../widgets/character/character_list.dart';

class SearchCharacterView extends StatefulWidget {
  const SearchCharacterView({super.key});

  @override
  SearchCharacterViewState createState() => SearchCharacterViewState();
}

class SearchCharacterViewState extends StateMVC<SearchCharacterView> {
  SearchCharacterViewState() : super(HomeController()) {
    _con = controller as HomeController;
  }
  late HomeController _con;
  String layout = 'grid';

  @override
  void initState() {
    super.initState();
    _con.listenForCharacters();
    _con.initScrollCharacterController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'All Search Characters',
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _con.editTextController,
                      focusNode: _con.focusController,
                      onSubmitted: (val) {
                        _con.searchCharacter(val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search character',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        _con.cleanTextEditing();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (_con.characters.isEmpty)
                const Expanded(
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _con.refresh,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: _con.scrollCharacterController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  title: Text(
                                    'All characters',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            layout = 'list';
                                          });
                                        },
                                        icon: Icon(
                                          Icons.format_list_bulleted,
                                          color: layout == 'list'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context).focusColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            layout = 'grid';
                                          });
                                        },
                                        icon: Icon(
                                          Icons.apps,
                                          color: layout == 'grid'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context).focusColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                _con.isLoading && _con.characters.isEmpty
                                    ? const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: SpinKitThreeBounce(
                                            color: Colors.red,
                                            size: 30.0,
                                          ),
                                        ),
                                      )
                                    : _con.searchTerm != null &&
                                            _con.characters.isEmpty
                                        ? const SizedBox(
                                            height: 200,
                                            child: Center(
                                              child: Text(
                                                  'Personaje no encontrado'),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                if (_con.characters.isNotEmpty)
                                  layout != 'list' ? _grid() : _list(),
                                if (_con.searchTerm == null &&
                                    _con.characters.isNotEmpty)
                                  const Center(
                                    child: SpinKitThreeBounce(
                                      color: Colors.red,
                                      size: 30.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        controller: _con.scrollHomeController,
        itemCount: _con.characters.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          final character = _con.characters[index];
          return CharacterList(
            heroTag: 'character_list',
            character: character,
          );
        });
  }

  Widget _grid() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 500 ? 4 : 2,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        shrinkWrap: true,
        primary: false,
        controller: _con.scrollHomeController,
        itemCount: _con.characters.length,
        itemBuilder: (context, index) {
          final character = _con.characters[index];
          return CharacterGrid(
            heroTag: 'character_grid',
            character: character,
          );
        });
  }
}
