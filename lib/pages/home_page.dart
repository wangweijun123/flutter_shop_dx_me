import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_dx_me/log/log_constanst.dart';
import 'package:flutter_shop_dx_me/service/http_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../config/color.dart';
import '../config/font.dart';
import '../config/string.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //火爆专区分页
  int page = 1;

  //火爆专区数据
  List<Map> hotGoodsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myPrint('首页刷新了...');
    _getHotGoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: request('homePageContext', formData: null),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            // myPrint(data.toString());

            List<Map> swiperDataList =
                (data['data']['slides'] as List).cast(); //轮播图
            List<Map> navigatorList =
                (data['data']['category'] as List).cast(); //分类
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast(); //商品推荐
            List<Map> floor1 = (data['data']['floor1'] as List).cast(); //底部商品推荐
            Map fp1 = data['data']['floor1Pic']; //广告
            myPrint("111 = $swiperDataList");
            // myPrint("2222= $navigatorList");
            // myPrint("333 = $floor1");
            // myPrint("444 = $fp1");
            return ListView(
              children: [
                SwiperDiy(swiperDataList: swiperDataList),
                TopNavigator(navigatorList: navigatorList),
                RecommendUI(
                  recommandList: recommendList,
                ),
                FloorPic(
                  floorPic: fp1,
                ),
                Floor(floor: floor1),
                _hotGoods(),
              ],
            );
          } else {
            return Text("no data");
          }
        },
      ),
    );
  }

  void _getHotGoods() {
    var formPage = {'page': page};
    request('getHotGoods', formData: formPage).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      myPrint("_getHotGoods newGoodsList.size = ${newGoodsList.length}");
      //设置火爆专区数据列表
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  //火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            // Application.router
            //     .navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(375),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '￥${val['presentPrice']}',
                      style: TextStyle(color: KColor.presentPriceTextColor),
                    ),
                    Text(
                      '￥${val['oriPrice']}',
                      style: TextStyle(color: KColor.oriPriceColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  //火爆专区组合
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }

  //火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
      ),
    ),
    //火爆专区
    child: Text(
      KString.hotGoodsTitle,
      style: TextStyle(color: KColor.homeSubTitleTextColor),
    ),
  );
}

class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  const SwiperDiy({super.key, required this.swiperDataList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Image.network(
              "${swiperDataList[index]['image']}",
              fit: BoxFit.cover,
            ),
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List<Map> navigatorList;

  const TopNavigator({super.key, required this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, Map item, int index) {
    return InkWell(
      onTap: () {
        //跳转到分类页面
        // _goCategory(context, index, item['firstCategoryId']);
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['firstCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tempIndex = -1;
    return Container(
      height: ScreenUtil().setHeight(320),
      child: GridView.count(
        crossAxisCount: 5,
        children: navigatorList.map((item) {
          tempIndex++;
          return _gridViewItemUI(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
}

//商品推荐
class RecommendUI extends StatelessWidget {
  final List recommandList;

  RecommendUI({super.key, required this.recommandList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList(context),
        ],
      ),
    );
  }

  //推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor)),
      ),
      child: Text(
        KString.recommendText, //'商品推荐',
        style: TextStyle(color: KColor.homeSubTitleTextColor),
      ),
    );
  }

  //商品推荐列表
  Widget _recommedList(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(280),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommandList.length,
          itemBuilder: (context, index) {
            return _item(index, context);
          }),
    );
  }

  Widget _item(index, context) {
    return InkWell(
      onTap: () {
        // Application.router.navigateTo(
        //     context, "/detail?id=${recommandList[index]['goodsId']}");
        var item = recommandList[index];
        myPrint("push index = $index, item = ${item} ");

        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(item['goodsId']),
            // settings: const RouteSettings(
            //   arguments: {'id': '123'},
            // ),
          ),
        );*/
      },
      child: Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
          ),
        ),
        child: Column(
          children: <Widget>[
            //仿止溢出
            Expanded(
              child: Image.network(
                recommandList[index]['image'],
                fit: BoxFit.contain,
              ),
            ),
            Text(
              '￥${recommandList[index]['presentPrice']}',
              style: TextStyle(color: KColor.presentPriceTextColor),
            ),
            Text(
              '￥${recommandList[index]['oriPrice']}',
              style: KFont.oriPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

//商品推荐中间广告
class FloorPic extends StatelessWidget {
  final Map floorPic;

  FloorPic({super.key, required this.floorPic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: InkWell(
        child: Image.network(
          floorPic['PICTURE_ADDRESS'],
          fit: BoxFit.cover,
        ),
        onTap: () {},
      ),
    );
  }
}

//商品推荐下层
class Floor extends StatelessWidget {
  List<Map> floor;

  Floor({super.key, required this.floor});

  void jumpDetail(context, String goodId) {
    //跳转到商品详情
    // Application.router.navigateTo(context, "/detail?id=${goodId}");
  }

  @override
  Widget build(BuildContext context) {
    // screenWidth

    double width = ScreenUtil.defaultSize.width;
    return Container(
      child: Row(
        children: <Widget>[
          //左侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                //左上角大图
                Container(
                  padding: EdgeInsets.only(top: 4),
                  height: ScreenUtil().setHeight(400),
                  child: InkWell(
                    child: Image.network(
                      floor[0]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[0]['goodsId']);
                    },
                  ),
                ),
                //左下角图
                Container(
                  padding: EdgeInsets.only(top: 1, right: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[1]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[1]['goodsId']);
                    },
                  ),
                ),
              ],
            ),
          ),
          //右侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                //右上图
                Container(
                  padding: EdgeInsets.only(top: 4, left: 1, bottom: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[2]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[2]['goodsId']);
                    },
                  ),
                ),
                //右中图
                Container(
                  padding: EdgeInsets.only(top: 1, left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[3]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[3]['goodsId']);
                    },
                  ),
                ),
                //右下图
                Container(
                  padding: EdgeInsets.only(top: 1, left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[4]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[4]['goodsId']);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
