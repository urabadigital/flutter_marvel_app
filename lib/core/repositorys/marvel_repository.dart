import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

import '../../helper/const/consts.dart';
import '../../helper/const/keys.dart';
import '../models/character.dart';
import '../models/comic.dart';

const timestamp = '1';
const itemsPerPage = 20;

generateMd5(String data) {
  String md = md5.convert(utf8.encode(data)).toString();
  return md;
}

@override
Future<List<Character>> getCharacters({
  required int page,
  required int offset,
  String? searchTerm,
}) async {
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    offset = ((page - 1) * itemsPerPage);
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
      "limit": itemsPerPage.toString(),
      "offset": offset.toString(),
    };

    if (searchTerm != null) {
      queryParameters['nameStartsWith'] = searchTerm;
    }
    var response =
        await Dio().get(Const.characterApi, queryParameters: queryParameters);
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
    }
    final jsonValue = jsonDecode(response.toString());
    final object = CharactersResponse.fromJson(jsonValue);
    return object.data?.characters ?? <Character>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<Comic>> getComics({
  int page = 1,
  int? offset,
  String? searchTerm,
}) async {
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    offset = ((page - 1) * itemsPerPage);
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
      "limit": itemsPerPage.toString(),
      "offset": offset.toString(),
    };

    if (searchTerm != null) {
      queryParameters['titleStartsWith'] = searchTerm;
    }

    var response = await Dio().get(
      Const.comicsApi,
      queryParameters: queryParameters,
    );
    final jsonValue = jsonDecode(response.toString());
    final object = ComicsResponse.fromJson(jsonValue);
    return object.data?.comics ?? <Comic>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<Comic>> getPopularComics(int characterId) async {
  final url =
      'http://gateway.marvel.com/v1/public/characters/$characterId/comics';
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
    };
    var response = await Dio().get(
      url,
      queryParameters: queryParameters,
    );
    final jsonValue = jsonDecode(response.toString());
    final object = ComicsResponse.fromJson(jsonValue);
    return object.data?.comics ?? <Comic>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<Character>> getCharacterComics(int comicId) async {
  final url = 'http://gateway.marvel.com/v1/public/comics/$comicId/characters';
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
    };
    var response = await Dio().get(
      url,
      queryParameters: queryParameters,
    );
    final jsonValue = jsonDecode(response.toString());
    final object = CharactersResponse.fromJson(jsonValue);
    return object.data?.characters ?? <Character>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<Creator>> getCreatorComics(int comicId) async {
  final url = 'http://gateway.marvel.com/v1/public/comics/$comicId/creators';
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
    };
    var response = await Dio().get(
      url,
      queryParameters: queryParameters,
    );
    final jsonValue = jsonDecode(response.toString());
    final object = ComicsResponse.fromJson(jsonValue);
    return object.data?.creators ?? <Creator>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<Comic>> getCreatorPopularComics(int creatorId) async {
  final url = 'http://gateway.marvel.com/v1/public/creators/$creatorId/comics';
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
    };
    var response = await Dio().get(
      url,
      queryParameters: queryParameters,
    );
    final jsonValue = jsonDecode(response.toString());
    final object = ComicsResponse.fromJson(jsonValue);
    return object.data?.comics ?? <Comic>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<Comic>> getAllWithOutComics({
  String? searchName = '',
  int? limit = 20,
}) async {
  final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey);
  try {
    Map<String, dynamic> queryParameters = {
      "apikey": Keys.publicKey,
      "hash": hash,
      "ts": timestamp,
      "title": searchName,
      "limit": limit.toString(),
    };
    var response = await Dio().get(
      Const.comicsApi,
      queryParameters: queryParameters,
    );
    final jsonValue = jsonDecode(response.toString());
    final object = ComicsResponse.fromJson(jsonValue);
    return object.data?.comics ?? <Comic>[];
  } catch (e) {
    throw Exception(e.toString());
  }
}
