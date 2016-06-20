import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(
    new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: new FlutterDemo()
    )
  );
}

class FlutterDemo extends StatefulWidget {
  FlutterDemo({ Key key }) : super(key: key);

  @override
  _FlutterDemoState createState() => new _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    read();
  }

  Future<Null> write() async {
    Directory dir = await PathProvider.getApplicationDocumentsDirectory();
    IOSink file = new File(dir.path + '/count.txt').openWrite();
    file.write('$_counter');
    print("Wrote $_counter");
    await file.close();
  }

  Future<Null> read() async {
    final Directory dir = await PathProvider.getApplicationDocumentsDirectory();
    File file = new File(dir.path + '/count.txt');
    if (await file.exists()) {
      final String content = await file.readAsString();
      setState(() {
        _counter = int.parse(content);
        print("Read $_counter");
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      write();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo')
      ),
      body: new Center(
        child: new Text('Button tapped $_counter time${ _counter == 1 ? '' : 's' }.')
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(
          icon: Icons.add
        )
      )
    );
  }
}
