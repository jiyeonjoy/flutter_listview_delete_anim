import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> tiles;
  List foos = [];

  @override
  void initState() {
    this.foos = ['foo1', 'foo2', 'foo3', 'foo4'];
    this.tiles = buildTile(this.foos);
    super.initState();
  }

  //function
  List<Widget> buildTile(List list) {
    List<Widget> x = [];
    for(var i = 0; i < list.length; i++) {
      x.add(
          new ItemCategory(
            key: new Key(list[i]),
            category: list[i],
            onPressed: () {
              setState(() {
                list.removeAt(i);
                this.tiles = buildTile(list); //updating List<Widget> tiles
              });
            },
          )
      );
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Categories'),
        ),
        body: new ListView(
            padding: new EdgeInsets.only(top: 8.0, right: 0.0, left: 0.0),
            children: this.tiles.toList())
    );
  }
}










class ItemCategory extends StatefulWidget {
  ItemCategory({Key key, this.category, this.onPressed}) : super(key: key);

  final String category;
  final VoidCallback onPressed;

  @override
  ItemCategoryState createState() => new ItemCategoryState();
}













class ItemCategoryState extends State<ItemCategory> with TickerProviderStateMixin {
  ItemCategoryState();

  AnimationController _controller;
  Animation<double> _animation;
  double flingOpening;
  bool startFling = true;

  void initState() {
    super.initState();
    _controller = new AnimationController(duration:
    const Duration(milliseconds: 246), vsync: this);

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  void _move(DragUpdateDetails details) {
    final double delta = details.primaryDelta / 304;
    _controller.value -= delta;
  }

  void _settle(DragEndDetails details) {
    if(this.startFling) {
      _controller.fling(velocity: 1.0);
      this.startFling = false;
    } else if(!this.startFling){
      _controller.fling(velocity: -1.0);
      this.startFling = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
    this.flingOpening = -(48.0/_width);

    return new GestureDetector(
        onHorizontalDragUpdate: _move,
        onHorizontalDragEnd: _settle,
        child: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      decoration: new BoxDecoration(
                        color: new Color(0xFFE57373),
                      ),
                      child: new IconButton(
                          icon: new Icon(Icons.delete),
                          color: new Color(0xFFFFFFFF),
                          onPressed: widget.onPressed
                      )
                  ),
                ],
              ),
            ),
            new SlideTransition(
                position: new Tween<Offset>(
                  begin:  Offset.zero,
                  end: new Offset(this.flingOpening, 0.0),
                ).animate(_animation),
                child: new Container(
                  decoration: new BoxDecoration(
                    border: new Border(
                      top: new BorderSide(style: BorderStyle.solid, color: Colors.black26),
                    ),
                    color: new Color(0xFFFFFFFF),
                  ),
                  margin: new EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                margin: new EdgeInsets.only(left: 16.0),
                                padding: new EdgeInsets.only(right: 40.0, top: 4.5, bottom: 4.5),
                                child: new Row(
                                  children: <Widget>[
                                    new Container(
                                      margin: new EdgeInsets.only(right: 16.0),
                                      child: new Icon(
                                        Icons.brightness_1,
                                        color: Colors.black,
                                        size: 35.0,
                                      ),
                                    ),
                                    new Text(widget.category),
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }
}