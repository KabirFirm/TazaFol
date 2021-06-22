import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  ScrollController scrollViewColtroller = ScrollController();

  @override
  void initState() {
    scrollViewColtroller = ScrollController();
    scrollViewColtroller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollViewColtroller.offset >=
        scrollViewColtroller.position.maxScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
        _direction = true;
      });
    }
    if (scrollViewColtroller.offset <=
        scrollViewColtroller.position.minScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        message = "reach the top";
        _direction = false;
      });
    }
  }

  String message = '';
  bool _direction = false;

  @override
  void dispose() {
    super.dispose();
    scrollViewColtroller.dispose();
  }

  _moveUp() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset - 50,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _moveDown() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset + 50,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Visibility(
              visible: _direction,
              maintainSize: false,
              child: FloatingActionButton(
                onPressed: () {
                  _moveUp();
                },
                child: RotatedBox(
                    quarterTurns: 1, child: Icon(Icons.chevron_left)),
              ),
            ),
            Visibility(
              maintainSize: false,
              visible: !_direction,
              child: FloatingActionButton(
                onPressed: () {
                  _moveDown();
                },
                child: RotatedBox(
                    quarterTurns: 3, child: Icon(Icons.chevron_left)),
              ),
            )
          ],
        ),
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollViewColtroller.position.userScrollDirection ==
                ScrollDirection.reverse) {
              print('User is going down');
              setState(() {
                message = 'going down';
                _direction = true;
              });
            } else {
              if (scrollViewColtroller.position.userScrollDirection ==
                  ScrollDirection.forward) {
                print('User is going up');
                setState(() {
                  message = 'going up';
                  _direction = false;
                });
              }
            }
            return true;
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 100.0,
                color: Colors.green,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                    controller: scrollViewColtroller,
                    children: List.generate(10, (i) {
                      return DummyContainers(
                        i: i,
                      );
                    }).toList(),
                  ))
            ],
          ),
        ));
  }
}

class DummyContainers extends StatelessWidget {
  final int i;
  DummyContainers({this.i});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Title $i'),
        subtitle: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras interdum, felis nec aliquam feugiat, est urna pharetra metus, a aliquam neque nisl vitae elit. Cras diam libero, volutpat a mattis et, venenatis ac sem.'),
      ),
    );
  }
}



