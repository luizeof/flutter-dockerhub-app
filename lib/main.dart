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
  database = await Hive.openBox('repositories');
  settings = await Hive.openBox('settings');

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
                icon: Icon(isEditMode ? Icons.close : Icons.edit),
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
            child: ValueListenableBuilder(
                valueListenable: Hive.box('repos').listenable(),
                builder: (context, box, widget) {
                  var _items = List.from(database.values);
                  var _images = <DockerImage>[];

                  for (int i = 0; i <= _items.length - 1; i++) {
                    try {
                      _images.add(DockerImage.fromJson(
                          jsonDecode(_items[i].toString())));
                    } catch (e) {}
                  }

                  return new ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return (isEditMode == true)
                          ? deleteListItem(_images[index], context)
                          : listItem(_images[index], context);
                    },
                  );
                }),
          ),
        ),
      ),
      routes: {
        '/detail': (context) => new DetailPage(),
        '/add': (context) => new AddPage(),
      },
    );
  }
}
