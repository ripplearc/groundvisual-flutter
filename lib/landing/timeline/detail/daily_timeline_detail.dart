import 'package:flutter/material.dart';

class HeroType {
  String title;
  String subTitle;
  String image;
  Color materialColor;

  HeroType({this.title, this.subTitle, this.image, this.materialColor});
}

class DailyTimelineDetail extends StatefulWidget {
  final HeroType heroType;

  const DailyTimelineDetail({Key key, this.heroType}) : super(key: key);

  @override
  _DailyTimelineDetailState createState() => _DailyTimelineDetailState();
}

class _DailyTimelineDetailState extends State<DailyTimelineDetail> {
  HeroType _heroType;
  double _screenWidth;

  @override
  void initState() {
    super.initState();
    _heroType = widget.heroType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_heroType.title}'),
        backgroundColor: _heroType.materialColor,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'background' + _heroType.title,
              child: Container(
                color: _heroType.materialColor,
              ),
            ),
            Positioned(
                top: 0.0,
                left: 0.0,
                width: _screenWidth,
                height: 230.0,
                child: Hero(
                    tag: 'image' + _heroType.image,
                    child: Image.asset(
                      _heroType.image,
                      fit: BoxFit.fitWidth,
                    ))),
            Positioned(
                top: 250.0,
                left: 32.0,
                width: _screenWidth - 64.0,
                child: Hero(
                    tag: 'text' + _heroType.title,
                    child: Material(
                        color: Colors.transparent,
                        child: Text(
                          '${_heroType.title}',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: _heroType.materialColor),
                        )))),
            Positioned(
                top: 280.0,
                left: 32.0,
                width: _screenWidth - 64.0,
                child: Hero(
                    tag: 'subtitle' + _heroType.title,
                    child: Material(
                        color: Colors.transparent,
                        child: Text(
                          _heroType.subTitle,
                        )))),
          ],
        ),
      ),
    );
  }
}
