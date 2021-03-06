// 自定义组件 StatefulWidget 有状态
import 'package:flutter/material.dart';
// 导入dio
import 'package:dio/dio.dart';
//import 'package:webview_flutter/webview_flutter.dart';
// 详情页
import './detail.dart';

Dio dio = new Dio();

class HomelistPage extends StatefulWidget {
  // 传入参数 构造函数
  @override
//HomelistPage({Key key}):super(key key);
  HomelistPage({Key key, @required this.keypram}) : super(key: key);
  // 数据请求
  //  flutter 提供了 HttpClient发起请求  但本身功能有缺陷 所以官方建议用dio发起请求 支持 Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载……
  final String keypram;
  // 关联管理状态类
  _HomelistPageState createState() {
    return _HomelistPageState();
  }
}

// 定义一个状态管理类 来进行管理 _  + 类名 + state
//  State<> 泛型
// 解决tab页滚动时状态保持不变 with AutomaticKeepAliveClientMixin 实现  bool get wantKeepAlive => true;
class _HomelistPageState extends State<HomelistPage>
    with AutomaticKeepAliveClientMixin {
// 新增下拉刷新
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  int page = 1;
  int pagesize = 10;
  List mlist = List();
  var total = 0;
  ScrollController subScrollView = ScrollController();
  // 刷新
  listShowRefreshLoading() {
    // 动画
    Future.delayed(const Duration(seconds: 0), () {
      refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  // 下拉刷新
  Future<Null> listOnRefresh() {
    return Future.delayed(const Duration(seconds: 2), () {
      page = 1;
      total = 0;
      mlist.clear();
      getHomeList();
    });
  }

  // 加载更多
  Future<Null> listMoreData() {
    return Future.delayed(const Duration(seconds: 1), () {
      page++;
      getHomeList();
    });
  }

  // // 调用数据请求
  @override
  void initState() {
    listShowRefreshLoading();
    subScrollView.addListener(() {
      if (subScrollView.position.pixels ==
          subScrollView.position.maxScrollExtent) {
        listMoreData();
      }
    });
    super.initState();

    // getHomeList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // 使用HomelistPage的属性
    //getHomeList();
    //return Text('首页列表页 ----' + widget.keypram + ' +++  ${mlist.length}');
    // 实现父类方法
    super.build(context);
    return RefreshIndicator(
      child: ListView.builder(
        controller: subScrollView,
        itemCount: mlist.isEmpty ? 0 : mlist.length + 1,
        itemBuilder: (BuildContext context, int i) {
          try {
            if (i == mlist.length) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          value: 1.0,
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        // 作为间隔用 SizedBox
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "正在加载",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.deepOrange),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            var itmes = mlist[i];
            List avatar = itmes['casts'];
            return GestureDetector(
              onTap: () {
                //print(itmes['id']);
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return new MovieDetail(
                    id: itmes['id'],
                    //id: '你好',
                    title: itmes['title'],
                  );
                }));
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    // 分割新
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: Row(
                  children: [
                    // Image.network(
                    //   itmes['images']['small'],
                    //   height: 170,
                    //   width: 125,
                    //   fit: BoxFit.cover,
                    // ),
                    // 图片加占位符
                    FadeInImage.assetNetwork(
                      placeholder: 'images/z1502640178971_350771.jpg',
                      image: itmes['images']['small'],
                      height: 170,
                      width: 125,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      // 图片和文字间距
                      padding: EdgeInsets.only(left: 10),
                      // 之间的间距200 row
                      height: 200,
                      child: Column(
                        children: [
                          Text('影片名称: ${itmes['title']}'),
                          Text('上映时间: ${itmes['year']} 年'),
                          Text('电影类型: ${itmes['genres'].join(' , ')}'),
                          Text('豆瓣评分: ${itmes['rating']['average']} 分'),
                          //Text('主要演员: ${itmes['title']}'), 主要演员 图片
                          //var avatar = itmes['avatars'];
                          Container(
                            height: 50,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(15)
                            //   ),
                            child: Row(
                              children: [
                                Text('主要演员:'),
                                //Text('主要演员:'),
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15)),
                                  // 加圆角
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'images/ic_device_image_default.png',
                                      image: avatar.length > 0
                                          ? avatar[0]['avatars']['small']
                                          : "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // 下面的情况无法加图
                                  // child: FadeInImage.assetNetwork(
                                  //   placeholder: 'images/z1502640178971_350771.jpg',
                                  //   image: avatar[0]['avatars']['small'],
                                  //   fit: BoxFit.cover,
                                  // )
                                  // child: Image.network(
                                  //   avatar[0]['avatars']['small'],
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15)),
                                  // 加圆角
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'images/ic_device_image_default.png',
                                      image: avatar.length > 1
                                          ? avatar[1]['avatars']['small']
                                          : "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15)),
                                  // 加圆角
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'images/ic_device_image_default.png',
                                      image: avatar.length > 2
                                          ? avatar[2]['avatars']['small']
                                          : "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // text间距
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                    )
                  ],
                ),
              ),
            );
          } catch (e) {
            return Text("    ");
          }

          // return
          //return Text(itmes["title"]);
        },
      ),
      onRefresh: listOnRefresh,
      key: refreshKey,
    );
  }

// Can't access 'this' in a field initializer to read 'page
//The instance member 'page' can't be accessed in an  initializer. Try replacing the reference to the instance member with a different
//int offset = (this.page - 1) * this.pagesize; 必须写到getHomeList方法里面
  getHomeList() async {
    int offset = (this.page - 1) * this.pagesize;
    // dio.get(url,data) data是可选的
    var response = await dio.get(
        'http://www.liulongbin.top:3005/api/v2/movie/${widget.keypram}?start=$offset&count=$pagesize');
    // 返回的数据data
    try {
      var result = response.data;
      print(result);
      // 给私有数据赋值 用setState 不然界面不刷新
      setState(() {
        //mlist.add(result['subjects']);
        List subjectslist = result['subjects'];
        if (subjectslist.isEmpty) {
          return;
        }
        // 这里使用addAll add不对
        mlist.addAll(result['subjects']);
        //= result['subjects'];
        total = result['total'];
      });
    } catch (e) {}
  }
}
