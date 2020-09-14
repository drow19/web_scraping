import 'package:flutter/material.dart';
import 'package:fluttermovie/model/helper_model.dart';
import 'package:fluttermovie/view/filter_screen.dart';

class FilterBy extends StatefulWidget {
  @override
  _FilterByState createState() => _FilterByState();
}

class _FilterByState extends State<FilterBy> {
  List<String> _filter = ['Genre', 'Alphabetical'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            child: ListView.builder(
                itemCount: _filter.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _tabItem(index);
                }),
          ),
          SizedBox(
            height: 8,
          ),
          selectedIndex == 0 ? Genre() : Alphabet()
        ],
      ),
    );
  }

  Widget _tabItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _filter[index],
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: selectedIndex == index ? Colors.green : Colors.grey),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 2,
              width: 40,
              color: selectedIndex == index ? Colors.green : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}

class Genre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 0.3;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
          itemCount: genre.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisCount: 4),
          itemBuilder: (context, index) {
            return _list(context, genre[index]['title']);
          }),
    );
  }

  Widget _list(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterScreen(
                      query: title,
                      category: "genre",
                    )));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xffe53935), borderRadius: BorderRadius.circular(4)),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class Alphabet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 0.8;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
          itemCount: alpha.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            return _list(
                context, alpha[index]['id'], alpha[index]['url'], index);
          }),
    );
  }

  Widget _list(BuildContext context, String title, String url, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterScreen(
                      query: title,
                      category: "alphabet",
                    )));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xffe53935), borderRadius: BorderRadius.circular(4)),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
