import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/helper/helper.dart';
import 'package:fluttermovie/model/filter_model.dart';
import 'package:fluttermovie/view/detail_screen.dart';
import 'package:fluttermovie/widget/star_display.dart';
import 'package:fluttermovie/widget/widget.dart';

class FilterScreen extends StatefulWidget {
  final query;
  final category;

  FilterScreen({@required this.query, this.category});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<FilterModel> _list = new List<FilterModel>();
  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Helper _helper = new Helper();
  bool _isloadingTopbar = false;
  bool _isloading = false;
  bool hasReachMax = false;
  String _url;
  int page = 1;

  scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        hasReachMax = true;
        page++;
        print("print : $page");
      });
      getData();
    }
  }

  getData() async {
    if (hasReachMax == false) {
      setState(() {
        _isloading = true;
      });
    } else {
      _isloadingTopbar = true;
    }
    await _helper
        .filterAnime(widget.query, "$page", widget.category)
        .then((value) {
      setState(() {
        if (hasReachMax == true) {
          _isloadingTopbar = false;
          List<FilterModel> newList = value;
          _list = [..._list, ...newList];
        } else {
          _isloading = false;
          _list = value;
        }
      });
    }).catchError((e) {
      print("print error : $e");
    });
  }

  @override
  void dispose() {
    _list = [];
    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
    _scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff424242),
        actions: [
          _isloadingTopbar
              ? Center(
                  child: Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )),
                )
              : Container(),
        ],
      ),
      body: _isloading
          ? loadingView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: GridView.builder(
                      controller: _scrollController,
                      itemCount: _list.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return _listAnime(
                            _list[index].title,
                            _list[index].images,
                            _list[index].url,
                            _list[index].rating);
                      }),
                )
              ],
            ),
    );
  }

  Widget _listAnime(String title, String images, String url, String rating) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailScreen(url: url)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: images,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: standardFont(),
                    textAlign: TextAlign.center,
                  ),
                  StarDisplayWidget(
                    value: int.parse(rating),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
