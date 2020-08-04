import 'package:flutter/material.dart';
import 'package:myapp/home/homepage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../home/baseWebview.dart';

Dio detailDio = Dio();

class MovieDetail extends StatefulWidget {
  MovieDetail({Key key, @required this.id, @required this.title})
      : super(key: key);
  final String id;
  final String title;

  @override
  _MovieDetailState createState() {
    return _MovieDetailState();
  }
}

class _MovieDetailState extends State<MovieDetail> {
  var detailDic = {};
  @override
  Widget build(BuildContext context) {
    //return Text('详情页 + ${widget.id} + ${widget.title}');
    requestDetaiData();
    // print(detailDic);
    var largeImage = '';
    var textDetial = '';
    var bringDetailURL = '';
    final size = MediaQuery.of(context).size;
    try {
      largeImage = detailDic['images']['large'];
      textDetial = detailDic['summary'];
      bringDetailURL = detailDic['mobile_url'];
    } catch (e) {}

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        // body: Text('电影列表id:${widget.id}'),
        // ScrollView 是抽象类
        body: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext ctx) {
              return new BaseWebView(
                  webURL: bringDetailURL, navTtile: widget.title);
            }));
          },
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(0),
                sliver: SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/z1502640178971_350771.jpg',
                    image: largeImage,
                    width: size.width,
                    height: size.height / 2,
                  ),
                  Text(textDetial)
                ])),
              ),
              // Text(textDetial)
            ],
          ),
        ));
  }

  // 请求详情页
  requestDetaiData() async {
    var detailReponse = await dio.get(
        'http://www.liulongbin.top:3005/api/v2/movie/subject/${widget.id}');
    print('http://www.liulongbin.top:3005/api/v2/movie/subject/${widget.id}');
    try {
      var detailData = detailReponse.toString();
      //print('data' + detailData);
      setState(() {
        detailDic = json.decode(detailData);
        //print(detailReponse.extra);
        //print(detailDic);
      });
    } catch (e) {}
  }
}
