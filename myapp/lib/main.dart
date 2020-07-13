//import 'dart:html';

import 'package:flutter/material.dart';

//import 'package:english_words/english_words.dart';

// =>  flutter单行函数或者方法的简写
// void main() => runApp(new MyApp());

// //StatelessWidget
// class MyApp extends StatelessWidget {
//   // dart语言风格
//   // dart语言没有pulick private
//   printInteger(int aNumber) {
//     print('the number $aNumber');
//   }

// //class MyApp extends StatelessWidget {
//   @override
//   // Widget build(BuildContext context) {
//   //   return new MaterialApp(
//   //     title: '首页',
//   //     //Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性
//   //     home: new Scaffold(
//   //       appBar: new AppBar(
//   //         title: new Text('首页11'),
//   //       ),
//   //       body: new Center(
//   //         child: new Text('欢迎使用flutter'),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget build(BuildContext context) {
//     //final wordPair = new WordPair.random();
//     var numbers = 42;
//     printInteger(numbers);
//     // var appBar2 = new AppBar(
//     //       title: new Text('App开发'),
//     //       // 标题的位置置于中间
//     //       centerTitle: true,
//     //       // 颜色
//     //       //backgroundColor:Color(),
//     //     );
//     return new MaterialApp(
//       title: '首页',//安卓的标题
//       ///caffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性
//       home: MyFristPage();

//     //   new Scaffold(
//     //     appBar: appBar2,
//     //     body: new Center(
//     //       //child: new Text('使用flutter心酸啊'),
//     //       child: new Text(wordPair.asPascalCase),
//     //     ),
//     //   ),
//     // );
//   }
// }

// class MyFristPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Text('你好');
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 安卓中体现
      title: '首页',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // 修改颜色
        primarySwatch: Colors.pink,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 返回一个Scaffold
      home: myFirstPage(),
      //Text("hello word"),
    );
  }
}

// ignore: camel_case_types
class myFirstPage extends StatelessWidget {
  @override
  // 每个类中都有一个bulid
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        // 是否居中 ios中默认居中 安卓在左边
        centerTitle: true,
        // 颜色
        backgroundColor: Colors.red,
        // 字体颜色和样式
        textTheme: TextTheme(),
        // 右边放一个按钮
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // 写个弹框
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('提示'),
                        content: Text('内容详情'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                //NavigatorUtils.goBack(context);
                                Navigator.of(context).pop();
                                //Navigator.pop(context);
                              },
                              child: Text('取消')),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Navigator.pop(context)
                              },
                              child: Text('确定'))
                        ],
                      );
                    });
              })
        ],
      ),
      // Drawer侧滑效果
      drawer: Drawer(
        child: ListView(
          // 头部有空隙的解决办法
          padding: EdgeInsets.all(0),
          children: [
            // 头部
            UserAccountsDrawerHeader(
              accountName: Text(
                '张三',
                style: TextStyle(
                  // 字体颜色
                  color: Colors.red,
                ),
                // 设置字体段落
                strutStyle: StrutStyle(
                  // 字体大小
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
              accountEmail: Text('abc@qq.com'),
              currentAccountPicture: CircleAvatar(
                // 颜色设置为透明
                backgroundColor: Color(0x00FFFFFF),
                // 网页图片
                backgroundImage: NetworkImage(
                    'http://gx.10086.cn/zt-portal/gxhzg/nav/upload//pageDesign/s2Ip1Rbvdfm30xeZMDVe.png'),
                // backgroundImage:
                //     Image.asset('images/z1502640178971_350771.jpg'),
              ),
              decoration: BoxDecoration(
                // 让图片拉升 布满整个屏幕
                image: DecorationImage(
                  fit: BoxFit.cover,
                  // 这里可以加载网页图片 NetworkImage
                  image: AssetImage('images/z1502640178971_350771.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
