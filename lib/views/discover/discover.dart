import 'package:flutter/material.dart';
import 'package:flutter_wechat/model/common/common_item.dart';

class Discover0 extends StatefulWidget {
  Discover0({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _DiscoverState();
  }
}

class _DiscoverState extends State<Discover0> {
  @override
  Widget build(BuildContext context) {
    return abc();
    // return ListView.builder(
    //   itemCount: 100,
    //   itemBuilder: (BuildContext context, int index) {
    //     print('idex is  $index');
    //     return abc();
    //   },
    // );
  }
}

class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return KeyOo();
  }
}

class abc extends StatelessWidget {
  const abc({Key key}) : super(key: key);
  Widget geWigets(int count) {
    print('获取数据');
    final lists = <Widget>[];
    for (var i = 0; i < count; i++) {
      final xx = new Container(
        alignment: Alignment.center,
        color: Colors.lightBlue[100 * (i % 9)],
        child: new Text('list item $i'),
        height: 50.0,
      );
      lists.add(xx);
    }
    // return Padding(
    //   padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
    //   // child: Column(
    //   //   children: lists,
    //   // ),
    //   child: ListView.builder(
    //     itemCount: 50,
    //     itemExtent: 50.0,
    //     itemBuilder: (BuildContext context, int index) {
    //     return new Text('list item $index');
    //    },
    //   ),
    // );
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: 50,
              itemExtent: 50.0,
              itemBuilder: (BuildContext context, int index) {
                return new Text('list item $index');
              }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: geWigets(1000),
    );
  }
}

class KeyOo extends StatefulWidget {
  KeyOo({Key key}) : super(key: key);

  _KeyOoState createState() => _KeyOoState();
}

class _KeyOoState extends State<KeyOo> {
  final slivers = <Widget>[];
  @override
  void initState() {
    // final item = CommonItem();
    final item0 = CommonItem.help(x: 10, y: 10);
    final item1 = CommonItemArrow();
    // print('object ${item.x} ${item.y}');
    print('object0 ${item0.x} ${item0.y}');
    print('object1 ${item1.x} ${item1.y}');

 


    super.initState();
    final a = new SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
              new SliverChildBuilderDelegate((BuildContext context, int index) {
            // print('list item $index');
            //创建列表项
            return new Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: new Text('list item $index'),
            );
          }, childCount: 50 //50个列表项
                  ),
        );
    slivers.add(a);
    Future.delayed(Duration(seconds: 4), () {
      print('666');
      final b = new SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
              new SliverChildBuilderDelegate((BuildContext context, int index) {
            // print('red item $index');
            //创建列表项
            return new Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: new Text('red item $index'),
            );
          }, childCount: 50 //50个列表项
                  ),
        );
        setState(() {
          // slivers.add(b);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: slivers,
    );
  }
}

class adc extends StatelessWidget {
  const adc({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        //AppBar，包含一个导航栏
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Demo'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: new SliverGrid(
            //Grid
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Grid按两列显示
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                print('grid item $index');
                //创建子widget
                return new Container(
                  alignment: Alignment.center,
                  color: Colors.cyan[100 * (index % 9)],
                  child: new Text('grid item $index'),
                );
              },
              childCount: 50,
            ),
          ),
        ),
        //List
        new SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
              new SliverChildBuilderDelegate((BuildContext context, int index) {
            // print('list item $index');
            //创建列表项
            return new Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: new Text('list item $index'),
            );
          }, childCount: 50 //50个列表项
                  ),
        ),
      ],
    );
  }
}