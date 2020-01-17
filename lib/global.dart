import 'package:docker_hub_api/docker_hub_api.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

DockerImage currentImage;

var themeProvider;

List<DockerRepository> dockerRepositories = <DockerRepository>[];

DateTime lastFetch = new DateTime(2020, 01, 01, 00, 00, 00);

List<DockerImage> imagesCache;

var database;

var settings;

bool isEditMode = false;

Future<List<DockerImage>> getImages() async {
  Duration difference = DateTime.now().difference(lastFetch);

  if (difference.inMinutes > 10) {
    var _images = <DockerImage>[];
    var _items = List.from(database.values);
    for (int i = 0; i <= _items.length - 1; i++) {
      var rep = DockerRepository(_items[i][0].toString());
      var img = await rep.getImage(_items[i][1].toString());
      _images.add(img);
    }
    lastFetch = DateTime.now();
    imagesCache = _images;
    return _images;
  } else {
    return imagesCache;
  }
}
