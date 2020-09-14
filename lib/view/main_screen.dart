import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/helper/helper.dart';
import 'package:fluttermovie/model/model.dart';
import 'package:fluttermovie/view/detail_screen.dart';
import 'package:fluttermovie/view/list_anime.dart';
import 'package:fluttermovie/widget/widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Helper _helper = new Helper();
  List<MainModel> _list = new List<MainModel>();

  bool _isLoading = false;

  getData() async {
    _isLoading = true;
    await _helper.getAnime().then((value) {
      setState(() {
        _isLoading = false;
        _list = value;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        title: Text('Anime'),
        backgroundColor: Color(0xff424242),
      ),
      body: _isLoading
          ? loadingView()
          : Column(
              children: [
                /*ListAlphabet()*/

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Anime Ongoing",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white)),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListAnime()));
                          },
                          child: Text(
                            "See All",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 14, color: Colors.green),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GridView.builder(
                        itemCount: _list.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return _listAnime(_list[index].title,
                              _list[index].images, _list[index].url);
                        }),
                  ),
                )
              ],
            ),
    );
  }

  Widget _listAnime(String title, String images, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => DetailScreen(url: url)
        ));
      },
      child: Container(
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
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                title,
                style: standardFont(),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
