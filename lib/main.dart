import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'package:docker_hub_api/docker_hub_api.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<DockerRepository> dockerRepositories = <DockerRepository>[];
var themeProvider;

void main() async {
  await Hive.initFlutter();
  var repo = new DockerRepository('luizeof');
  dockerRepositories.add(repo);
  var repo2 = new DockerRepository('nginx');

  dockerRepositories.add(repo2);
  runApp(
    ChangeNotifierProvider<DynamicDarkMode>(
      create: (_) => DynamicDarkMode(),
      child: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<DockerImage>> getImages() async {
    var _images = <DockerImage>[];
    for (int r = 0; r <= dockerRepositories.length - 1; r++) {
      await dockerRepositories[r].images();
      print(dockerRepositories[r].pageCount.toString());

      for (int i = 1; i <= dockerRepositories[r].pageCount; i++) {
        (await dockerRepositories[r].images(page: i)).forEach((e) {
          _images.add(e);
        });
      }
    }
    return _images;
  }

  Widget dockerImageMetaIconText(String _text, IconData _icon) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(3),
          child: Icon(_icon),
        ),
        Padding(
          padding: EdgeInsets.all(3),
          child: Text(_text),
        ),
      ],
    );
  }

  Widget dockerImageMetaIcon(IconData _icon) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Icon(_icon),
    );
  }

  Widget dockerImageMetaTitle(String _text) {
    return Text(
      _text,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget listItem(DockerImage _image) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Padding(
          padding: EdgeInsets.all(6),
          child: dockerImageMetaTitle("${_image.user} / ${_image.name}"),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              dockerImageMetaIconText(
                _image.pull_count.toString(),
                Icons.cloud_download,
              ),
              dockerImageMetaIconText(
                _image.star_count.toString(),
                Icons.star_border,
              ),
              dockerImageMetaIconText(
                _image.repository_type.toString(),
                Icons.label,
              ),
              dockerImageMetaIcon(
                (_image.is_private) ? Icons.lock : Icons.lock_open,
              ),
              dockerImageMetaIcon(
                (_image.is_automated) ? Icons.layers : Icons.layers_clear,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<DynamicDarkMode>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Docker Hub"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.brightness_4),
              onPressed: () {
                setState(
                  () {
                    themeProvider.isDarkMode
                        ? themeProvider.setLightMode()
                        : themeProvider.setDarkMode();
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: getImages(),
            builder: (BuildContext context,
                AsyncSnapshot<List<DockerImage>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Input a URL to start');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return new ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return listItem(snapshot.data[index]);
                      },
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
