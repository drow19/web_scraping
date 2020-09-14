import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/helper/helper.dart';
import 'package:fluttermovie/model/detail_model.dart';
import 'package:fluttermovie/widget/star_display.dart';
import 'package:fluttermovie/widget/widget.dart';

class DetailScreen extends StatefulWidget {
  final url;

  DetailScreen({@required this.url});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Helper _helper = new Helper();
  List<DetailModel> _list = new List<DetailModel>();
  DetailModel _detailModel = new DetailModel();

  bool _isloading = false;

  getData() async {
    _isloading = true;
    await _helper.detailAnime(widget.url).then((value) {
      setState(() {
        _isloading = false;
        _detailModel = value;
      });
    });
    await _helper.listEpisode(widget.url).then((value) {
      setState(() {
        _list = value;
      });
    }).catchError((e) {
      print("print error : $e");
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
        backgroundColor: Color(0xff424242),
      ),
      body: _isloading
          ? loadingView()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: _detailModel.images,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _detailModel.title,
                              style: titleText(18),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                _detailModel.rating == "0"
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
                                        value: int.parse(_detailModel.rating),
                                      ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  _detailModel.views,
                                  style: italicStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              _detailModel.airing,
                              style: standardFont(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    _detailModel.description,
                    style: italicStyle(),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'List Episode',
                    style: titleText(16),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(child: _listEpisode())
              ],
            ),
    );
  }

  Widget _listEpisode() {
    return ListView.builder(
        itemCount: _list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: _list[index].thumbnail,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        height: 80,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4)),
                        child: IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: null))
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Episode ${_list[index].episode}",
                      style: titleText(16),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Released " + _list[index].date,
                      style: italicStyle(),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
