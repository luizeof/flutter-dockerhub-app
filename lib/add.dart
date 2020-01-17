import 'package:flutter/material.dart';
import 'package:docker_hub_api/docker_hub_api.dart';
import 'components.dart';
import 'global.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool showDialog = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _textFieldController = TextEditingController();

  Future<List<DockerImage>> images;

  Future<List<DockerImage>> getImages() async {
    try {
      if (_textFieldController.text.isNotEmpty) {
        print(_textFieldController.text);
        var _images = <DockerImage>[];
        var repo = DockerRepository(_textFieldController.text);
        var test = await repo.images();
        if (test.length > 0) {
          for (int i = 1; i <= repo.pageCount; i++) {
            (await repo.images(page: i)).forEach((e) {
              _images.add(e);
            });
          }
          return _images;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Make Search
  _search() {
    if (_formKey.currentState.validate()) {
      setState(() {
        showDialog = false;
        images = getImages();
      });
    }
  }

  // Input Dialog
  openInput(BuildContext context, BoxConstraints viewportConstraints) {
    return new SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: Container(
          color: Colors.blueGrey,
          child: AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Repository Name',
                        hintText: 'Repository Name',
                        icon: Icon(Icons.person_outline),
                        fillColor: Colors.white,
                      ),
                      textInputAction: TextInputAction.go,
                      controller: _textFieldController,
                      onFieldSubmitted: (term) {
                        _search();
                      },
                      validator: (String value) {
                        return value.isEmpty
                            ? 'Please enter repository name.'
                            : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Search"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _search();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget notFound(BuildContext context, BoxConstraints viewportConstraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
          minWidth: viewportConstraints.maxWidth,
        ),
        child: Container(
          color: Colors.black12,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.report,
                  size: 64,
                ),
                Text(
                  _textFieldController.text,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Repository not Found.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Repository"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              setState(() {
                showDialog = true;
              });
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          if (showDialog == true) {
            return openInput(context, viewportConstraints);
          } else {
            return Container(
              child: FutureBuilder(
                future: images,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DockerImage>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Input a URL to start');
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    case ConnectionState.active:
                      return new Text('ACTIVE');
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return new Text(
                          '${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        );
                      } else if (snapshot.hasData) {
                        return new ListView.builder(
                          primary: false,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return addListItem(
                              snapshot.data[index],
                              context,
                            );
                          },
                        );
                      } else {
                        return notFound(context, viewportConstraints);
                      }
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
