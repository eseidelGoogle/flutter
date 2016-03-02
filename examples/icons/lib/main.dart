import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    new MaterialApp(
      title: "Material Icons",
      routes: <String, RouteBuilder>{
        '/': (RouteArguments args) => new IconsDemo()
      }
    )
  );
}

class IconTile extends StatelessComponent {
  String name;

  IconTile({this.name});

  void showIcon(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) {
        return new Scaffold(
          toolBar: new ToolBar(
            center: new Text(this.name)
          ),
          body: new Material(
            child: new Column(
              children: <Widget>[
                new Icon(
                  icon: this.name,
                  size: IconSize.s48
                ),
                new Text(this.name)
              ]
            )
          )
        );
      }
    ));
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () { showIcon(context); },
      child: new DecoratedBox(
        decoration: new BoxDecoration(backgroundColor: Colors.black),
        child: new Icon(
          icon: this.name,
          size: IconSize.s48,
          colorTheme: IconThemeColor.white
        )
      )
    );
  }
}

class IconsDemo extends StatefulComponent {
  State createState() => new IconsState();
}

class IconsState extends State {
  List<String> icons = [];

  void initState() {
    super.initState();
    AssetBundle bundle = DefaultAssetBundle.of(context);
    bundle.loadString('flutter.yaml').then((String contents) {
      YamlMap flutterYaml = loadYaml(contents);
      setState(() {
        icons = flutterYaml['material-design-icons'].map((icon){
          return icon['name'];
        }).toList();
      });
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      toolBar: new ToolBar(
        center: new Text("Material Icons")
      ),
      body: new ScrollableGrid(
        delegate: new MaxTileWidthGridDelegate(maxTileWidth: 96.0),
        children: icons.map((String iconName) {
          return new IconTile(name:iconName);
        })
        .toList()
      )
    );
  }
}
