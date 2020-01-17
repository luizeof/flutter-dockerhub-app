import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'global.dart';
import 'components.dart';
import 'package:docker_hub_api/docker_hub_api.dart';
import 'package:hive/hive.dart';
import 'detail.dart';
import 'add.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  database = await Hive.openBox('repos');
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
  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<DynamicDarkMode>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Docker Hub"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditMode = !isEditMode;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPage()));
                },
              ),
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
                          return (isEditMode == true)
                              ? deleteListItem(snapshot.data[index], context)
                              : listItem(snapshot.data[index], context);
                        },
                      );
                    }
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                getImages();
              });
            },
            child: Icon(Icons.navigation),
            backgroundColor: Colors.green,
          ),
        ),
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/detail': (context) => new DetailPage(),
        '/add': (context) => new AddPage(),
      },
    );
  }
}
