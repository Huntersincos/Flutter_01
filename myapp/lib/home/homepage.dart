// 自定义组件 StatefulWidget 有状态
import 'package:flutter/material.dart';

class HomelistPage extends StatefulWidget {
  @override
  // 关联管理状态类
  _HomelistPageState createState() {
    return _HomelistPageState();
  }
}

// 定义一个状态管理类 来进行管理 _  + 类名 + state
class _HomelistPageState extends State<HomelistPage> {
  @override
  Widget build(BuildContext context) {
    return Text('首页列表页');
  }
}
