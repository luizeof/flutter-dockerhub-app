import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

void main() async => runApp(
      ChangeNotifierProvider<DynamicDarkMode>(
        create: (_) => DynamicDarkMode(),
        child: MyHomePage(),
      ),
    );

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicDarkMode>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Spacer(),
              Text('Texto Padrão'),
              Spacer(),
              Icon(
                Icons.wb_sunny,
                size: 36.0,
              ),
              Spacer(),
              RaisedButton(
                child: Text('RaisedButton Padrão'),
                onPressed: () {},
              ),
              Spacer(),
              Text('Dark Mode Dinâmico'),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
