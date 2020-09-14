import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/helper/helper.dart';
import 'package:fluttermovie/model/search_model.dart';
import 'package:fluttermovie/view/detail_screen.dart';
import 'package:fluttermovie/widget/star_display.dart';
import 'package:fluttermovie/widget/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SearchModel> _list = new List<SearchModel>();

  Helper _helper = new Helper();

  TextEditingController _searchController = new TextEditingController();

  bool _isloading = false;

  getData() async {
    await _helper.searchData(_searchController.text).then((value) {
      setState(() {
        _isloading = false;
        _list = value;
      });
    }).catchError((e) {
      print("print error : $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff424242),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      hintText: "search wallpapers", border: InputBorder.none),
                )),
                InkWell(
                    onTap: () {
                      if (_searchController.text != "") {
                        setState(() {
                          _isloading = true;
                          getData();
                        });
                      }
                    },
                    child: Container(child: Icon(Icons.search)))
              ],
            ),
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
