import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeroType {
  String title;
  String subTitle;
  List<String> images;
  int initialImageIndex;
  Color materialColor;

  HeroType(
      {this.title,
      this.subTitle,
      this.images,
      this.initialImageIndex,
      this.materialColor});
}

class DailyTimelineDetail extends StatefulWidget {
  final HeroType heroType;

  const DailyTimelineDetail({Key key, this.heroType}) : super(key: key);

  @override
  _DailyTimelineDetailState createState() => _DailyTimelineDetailState();
}

class _DailyTimelineDetailState extends State<DailyTimelineDetail> {
  double _screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageAppBarContent(context),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  width: _screenWidth,
                  height: 50,
                  child: Text("$index"),
                );
              },
              childCount: 20,
            ),
          )
        ],
      ),
      // ListView(
      //   children: <Widget>[
      //     Container(
      //         width: _screenWidth - 64.0,
      //         child: Hero(
      //             tag: 'text' + widget.heroType.title,
      //             child: Material(
      //                 color: Colors.transparent,
      //                 child: Text(
      //                   '${widget.heroType.title}',
      //                   style: TextStyle(
      //                       fontSize: 24.0,
      //                       fontWeight: FontWeight.bold,
      //                       color: widget.heroType.materialColor),
      //                 )))),
      //     Container(
      //         width: _screenWidth - 64.0,
      //         child: Hero(
      //             tag: 'subtitle' + widget.heroType.title,
      //             child: Material(
      //                 color: Colors.transparent,
      //                 child: Text(
      //                   widget.heroType.subTitle,
      //                 )))),
      //   ],
      // ),
    );
  }

  Hero _buildImageAppBarContent(BuildContext context) {
    return Hero(
      tag: 'image' + widget.heroType.images[widget.heroType.initialImageIndex],
      child: Container(
          width: _screenWidth,
          height: 230.0,
          child: ListView.builder(
              controller: ScrollController(
                  initialScrollOffset:
                      widget.heroType.initialImageIndex * _screenWidth),
              scrollDirection: Axis.horizontal,
              itemCount: widget.heroType.images.length,
              itemBuilder: (_, index) => Container(
                    width: _screenWidth,
                    child: _buildImage(
                        widget.heroType.images[index] ??
                            'assets/icon/excavator.svg',
                        context),
                  ))),
    );
  }

  Widget _buildImage(String imageName, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, context);
    else
      return _buildRaster(imageName);
  }

  SvgPicture _buildSvg(String imageName, BuildContext context) =>
      SvgPicture.asset(
        imageName,
        color: Theme.of(context).colorScheme.primary,
        fit: BoxFit.contain,
      );

  Image _buildRaster(String imageName) => Image.asset(
        imageName,
        fit: BoxFit.fitHeight,
      );
}
