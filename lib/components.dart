import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docker_hub_api/docker_hub_api.dart';
import 'theme.dart';
import 'global.dart';

Widget dockerImageMetaIconText(
    String _text, IconData _icon, BuildContext context) {
  return Row(
    children: [
      Padding(
        padding: EdgeInsets.all(3),
        child: Icon(
          _icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(3),
        child: Text(_text),
      ),
    ],
  );
}

Widget dockerImageMetaIcon(IconData _icon, BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(3),
    child: Icon(
      _icon,
      color: Theme.of(context).primaryColor,
    ),
  );
}

Widget dockerImageMetaTitle(String _text, BuildContext context) {
  return Text(
    _text,
    style: TextStyle(fontSize: 18),
  );
}

Widget listItem(DockerImage _image, BuildContext context) {
  return Card(
    child: GestureDetector(
      child: ListTile(
        isThreeLine: true,
        title: Padding(
          padding: EdgeInsets.all(6),
          child:
              dockerImageMetaTitle("${_image.user} / ${_image.name}", context),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              dockerImageMetaIconText(
                _image.pull_count.toString(),
                Icons.cloud_download,
                context,
              ),
              dockerImageMetaIconText(
                _image.star_count.toString(),
                Icons.star_border,
                context,
              ),
              dockerImageMetaIconText(
                _image.repository_type.toString(),
                Icons.label,
                context,
              ),
              dockerImageMetaIcon(
                (_image.is_private) ? Icons.lock : Icons.lock_open,
                context,
              ),
              dockerImageMetaIcon(
                (_image.is_automated) ? Icons.layers : Icons.layers_clear,
                context,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        currentImage = _image;
        Navigator.pushNamed(context, "/detail");
      },
    ),
  );
}

Widget selectListItem(DockerImage _image, BuildContext context) {
  themeProvider = Provider.of<DynamicDarkMode>(context);

  return Card(
    child: ListTile(
      isThreeLine: true,
      title: Padding(
        padding: EdgeInsets.all(6),
        child: dockerImageMetaTitle(
          "${_image.user}/${_image.name}",
          context,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            dockerImageMetaIconText(
              _image.pull_count.toString(),
              Icons.cloud_download,
              context,
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.add_to_photos,
          color: Theme.of(context).primaryColor,
          size: 32,
        ),
        onPressed: () {
          database.put(_image.imageKey, [_image.user, _image.name]);
        },
      ),
    ),
  );
}
