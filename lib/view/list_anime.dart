import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/helper/helper.dart';
import 'package:fluttermovie/model/ongoing_model.dart';
import 'package:fluttermovie/view/detail_screen.dart';
import 'package:fluttermovie/view/search_screen.dart';
import 'package:fluttermovie/widget/filter_by.dart';
import 'package:fluttermovie/widget/star_display.dart';
import 'package:fluttermovie/widget/widget.dart';

class ListAnime extends StatefulWidget {
  @override
  _ListAnimeState createState() => _ListAnimeState();
}

class _ListAnimeState extends State<ListAnime> {
  List<OnGoing> _list = new List<OnGoing>();
  Helper _helper = new Helper();

  int page = 1;
  double _size = 0;
  bool _isloading = false;
  bool hasReachMax = false;
  bool _isloadingTopbar = false;

  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    await _helper.onGoing('$page').then((value) {
      setState(() {
        if (hasReachMax == true) {
          _isloadingTopbar = false;
          List<OnGoing> newList = value;
          _list = [..._list, ...newList];
        } else {
          _isloading = false;
          _list = value;
        }
      });
    }).catchError((e) {
      _isloadingTopbar = false;
      _isloading = false;
      print("print Error : ${e.toString()}");
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
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('List Anime'),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
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
          IconButton(
              icon: Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              }),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_size == 250) {
                    _size = 0;
                  } else {
                    _size = 250;
                  }
                });
              },
              child: Container(
                width: 100,
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Color(0xff757575),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Filter by',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      Icons.import_export,
                      size: 15,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: _size,
              child: FilterBy(),
            ),
            _isloading
                ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: loadingView(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _list.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _listAnime(
                              _list[index].title,
                              _list[index].images,
                              _list[index].url,
                              _list[index].genre,
                              _list[index].rating,
                              _list[index].views);
                        }),
                  )
          ],
        ),
      ),
    );
  }

  Widget _listAnime(String title, String images, String url, String genre,
      String rating, String view) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailScreen(url: url)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: images,
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
              width: 8,
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleText(16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        rating == "0"
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                child: Text(
                                  'No Ratings Yet',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[100],
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            : StarDisplayWidget(
                                size: 17,
                                value: int.parse(rating),
                              ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          view,
                          style: italicStyle(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      genre ?? "",
                      style: italicStyle(),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
