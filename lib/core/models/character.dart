class CharactersResponse {
  Data? data;

  CharactersResponse(this.data);

  CharactersResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  int? offset;
  int? limit;
  int? total;
  int? count;
  List<Character>? characters;

  Data({
    this.offset,
    this.limit,
    this.total,
    this.count,
    this.characters,
  });

  Data.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    limit = json['limit'];
    total = json['total'];
    count = json['count'];
    if (json['results'] != null) {
      characters = <Character>[];
      json['results'].forEach((v) {
        characters?.add(Character.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['limit'] = limit;
    data['total'] = total;
    data['count'] = count;
    if (characters != null) {
      data['results'] = characters?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Character {
  int? id;
  String? name;
  String? description;
  Thumbnail? thumbnail;
  DateTime? modified;
  List<Url>? urls;

  Character({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.modified,
    this.urls,
  });

  Character.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
    modified = DateTime.parse(json['modified']);
    if (json['urls'] != null) {
      urls = <Url>[];
      json['urls'].forEach((v) {
        urls?.add(Url.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Url {
  Url({
    this.type,
    this.url,
  });

  String? type;
  String? url;

  Url.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }
}

class Thumbnail {
  String? path;
  String? extension;

  Thumbnail({this.path, this.extension});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['extension'] = extension;
    return data;
  }
}
