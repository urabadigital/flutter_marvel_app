

import 'character.dart';

class ComicsResponse {
  Data? data;

  ComicsResponse(this.data);

  ComicsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

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
  List<Comic>? comics;
  List<Creator>? creators;

  Data({
    this.offset,
    this.limit,
    this.total,
    this.count,
    this.comics,
    this.creators,
  });

  Data.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    limit = json['limit'];
    total = json['total'];
    count = json['count'];
    if (json['results'] != null) {
      comics = <Comic>[];
      json['results'].forEach((v) {
        comics?.add(Comic.fromJson(v));
      });
    }
    if (json['results'] != null) {
      creators = <Creator>[];
      json['results'].forEach((v) {
        creators?.add(Creator.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['limit'] = limit;
    data['total'] = total;
    data['count'] = count;
    if (comics != null) {
      data['results'] = comics?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comic {
  int? id;
  String? title;
  String? variantDescription;
  String? description;
  String? format;
  int? pageCount;
  Thumbnail? thumbnail;
  List<Url>? urls;
  List<Price>? prices;
  List<Image>? images;

  Comic({
    this.id,
    this.title,
    this.variantDescription,
    this.description,
    this.format,
    this.pageCount,
    this.thumbnail,
    this.urls,
    this.prices,
    this.images,
  });

  Comic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    variantDescription = json['variantDescription'];
    description = json['description'];
    format = json['format'];
    pageCount = json['pageCount'];
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
    if (json['urls'] != null) {
      urls = <Url>[];
      json['urls'].forEach((v) {
        urls?.add(Url.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <Price>[];
      json['prices'].forEach((v) {
        prices?.add(Price.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Image>[];
      json['images'].forEach((v) {
        images?.add(Image.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['variantDescription'] = variantDescription;
    data['description'] = description;
    data['pageCount'] = pageCount;
    return data;
  }
}

class Price {
  Price({
    this.type,
    this.price,
  });

  String? type;
  double? price;

  Price.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = double.parse(json['price'].toString());
  }
}

class Image {
  String? path;
  String? extension;
  Image({
    this.path,
    this.extension,
  });
  Image.fromJson(Map<String, dynamic> json) {
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

class Creator {
  int? id;
  String? firstName;
  String? lastName;
  String? fullName;
  DateTime? modified;
  Thumbnail? thumbnail;
  List<Url>? urls;

  Creator({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.modified,
    this.thumbnail,
    this.urls,
  });

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    modified = DateTime.parse(json['modified']);
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
    if (json['urls'] != null) {
      urls = <Url>[];
      json['urls'].forEach((v) {
        urls?.add(Url.fromJson(v));
      });
    }
  }
}
