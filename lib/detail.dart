import 'package:flutter/material.dart';
import 'global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${currentImage.user}/${currentImage.name}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.open_in_new,
            ),
            onPressed: () {
              _launchURL(currentImage.publicUrl);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Text(currentImage.publicUrl),
                          IconButton(
                            icon: Icon(Icons.open_in_new),
                            onPressed: () {
                              _launchURL(currentImage.publicUrl);
                            },
                          )
                        ],
                      ),
                    ),
                    MarkdownBody(
                      data: currentImage.full_description,
                      onTapLink: (String url) {
                        _launchURL(url);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
