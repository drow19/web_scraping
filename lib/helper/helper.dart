import 'package:fluttermovie/model/detail_model.dart';
import 'package:fluttermovie/model/filter_model.dart';
import 'package:fluttermovie/model/model.dart';
import 'package:fluttermovie/model/ongoing_model.dart';
import 'package:fluttermovie/model/search_model.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class Helper {
  getAnime() async {
    List<MainModel> _list = new List<MainModel>();

    String _url = "https://";

    final response = await get(_url);
    final document = parse(response.body);

    String title;
    String images;
    String url;

    document
        .getElementsByClassName('MovieList Rows AX A04 B03 C20 D03 E20 Alt')
        .forEach((element) {
      element.getElementsByTagName('li').forEach((e) {
        title = e.getElementsByClassName('Title')[0].text;
        images = e.getElementsByTagName('img')[0].attributes['src'];
        url = e.getElementsByTagName('a')[0].attributes['href'];

        String x = url.replaceAll('/episodes/', "");
        String y = x.replaceAll("https://", "");
        String c;
        if(y.contains('-episode')){
          String z = y.replaceAll('-episode-', '');
          c = "https://" + z.substring(0, z.length-2);
        }else{
          c =  "https://" + y.replaceAll('/nonton/', "");
        }

        _list.add(MainModel(title: title, images: images, url: c));

      });
    });

    return _list;
  }

  onGoing(String page) async {
    List<OnGoing> _list = new List<OnGoing>();

    String _url = "https://";

    print("url : ${_url}");

    final response = await get(_url);
    final document = parse(response.body);

    String title;
    String images;
    String url;
    String view;
    String rate;
    String genre;

    document
        .getElementsByClassName('MovieList Rows AX A04 B03 C20 D03 E20 Alt')
        .forEach((element) {
      //loop class
      element.getElementsByTagName('li').forEach((e) {
        //loop tag li

        title = e.getElementsByClassName('Title')[0].text;
        images = e.getElementsByTagName('img')[0].attributes['src'];
        url = e.getElementsByTagName('a')[0].attributes['href'];
        view = e.getElementsByClassName('Views AAIco-remove_red_eye')[0].text;

        e.getElementsByClassName('Description').forEach((el) {
          final b = el.getElementsByTagName('a');
          for (int i = 0; i < b.length; i++) {
            genre = b[0].text; /*+ ", " + b[1].text;*/
          }
        });

        final rating = e.querySelectorAll(".post-ratings")[0].text;

        if (rating.contains("No Ratings Yet")) {
          rate = "0";
        } else {
          final sub1 = rating.substring(20);
          final sub2 =
              sub1.substring(0, 2).replaceAll(' ', "").replaceAll(".", "");
          rate = sub2;
        }

        _list.add(OnGoing(
            title: title,
            images: images,
            url: url,
            genre: genre,
            rating: rate,
            views: view));
      });
    });

    return await _list;
  }

  searchData(String query) async {
    String search = query.replaceAll(" ", "+");
    String _url = "https://";

    List<SearchModel> _list = new List<SearchModel>();

    final response = await get(_url);
    final document = parse(response.body);

    String title;
    String images;
    String url;
    String view;
    String rate;
    String genre;

    document
        .getElementsByClassName('MovieList Rows AX A04 B03 C20 D03 E20 Alt')
        .forEach((element) {
      //loop class
      element.getElementsByTagName('li').forEach((e) {
        //loop tag li

        title = e.getElementsByClassName('Title')[0].text;
        images = e.getElementsByTagName('img')[0].attributes['src'];
        url = e.getElementsByTagName('a')[0].attributes['href'];
        view = e.getElementsByClassName('Views AAIco-remove_red_eye')[0].text;

        e.getElementsByClassName('Description').forEach((el) {
          final b = el.getElementsByTagName('a');
          for (int i = 0; i < b.length; i++) {
            genre = b[0].text; /*+ ", " + b[1].text;*/
          }
        });

        final rating = e.querySelectorAll(".post-ratings")[0].text;

        if (rating.contains("No Ratings Yet")) {
          rate = "0";
        } else {
          final sub1 = rating.substring(20);
          final sub2 =
              sub1.substring(0, 2).replaceAll(' ', "").replaceAll(".", "");
          rate = sub2;
        }

        _list.add(SearchModel(
            title: title,
            images: images,
            url: url,
            genre: genre,
            rating: rate,
            views: view));
      });
    });

    return await _list;
  }

  filterAnime(String query, String page, String cat) async {
    List<FilterModel> _list = new List<FilterModel>();
    String _url;

    if (cat == "alphabet") {
      _url = "https://";
    } else if (cat == "genre") {
      _url = "https://";
    }

    print(_url);

    final response = await get(_url);
    final document = parse(response.body);

    String images;
    String url;
    String title;
    String rate;

    document.getElementsByTagName("tbody").forEach((element) {
      element.getElementsByTagName('tr').forEach((e) {
        images = e.getElementsByTagName('img')[0].attributes['src'];
        url = e.getElementsByTagName('a')[0].attributes['href'];

        e.getElementsByClassName('MvTbTtl').forEach((x) {
          title = x.getElementsByTagName('a')[0].text.substring(30);
        });

        final rating = e.getElementsByClassName('post-ratings')[0].text;

        if (rating.contains("No Ratings Yet")) {
          rate = "0";
        } else {
          final sub1 = rating.substring(20);
          final sub2 =
              sub1.substring(0, 2).replaceAll(' ', "").replaceAll(".", "");
          rate = sub2;
        }

        _list.add(
            FilterModel(title: title, images: images, url: url, rating: rate));
      });
    });

    return _list;
  }

  detailAnime(String _url) async {
    final response = await get(_url);
    final document = parse(response.body);

    String images;
    String title;
    String airing;
    String views;
    String rate;
    String paragraph;

    document.getElementsByClassName('TPost A Single').forEach((element) {
      element.getElementsByClassName("Image Auto").forEach((t) {
        images = t.getElementsByTagName('img')[0].attributes['src'];
      });

      title = element.getElementsByClassName('Title')[0].text;
      views =
          element.getElementsByClassName('Views AAIco-remove_red_eye')[0].text;

      final rating = element.getElementsByClassName("post-ratings")[0].text;
      if (rating.contains("No Ratings Yet")) {
        rate = "0";
      } else {
        final sub1 = rating.substring(20);
        final sub2 =
            sub1.substring(0, 2).replaceAll(' ', "").replaceAll(".", "");
        rate = sub2;
      }

      element.getElementsByClassName('extra').forEach((el) {
        airing = el.getElementsByTagName('a')[0].text;
      });

      element.getElementsByClassName('Description').forEach((b) {
        paragraph = b.getElementsByTagName('p')[0].text; /*+
            b.getElementsByTagName('p')[1].text;*/
      });
    });

    return DetailModel(
        images: images,
        rating: rate,
        views: views,
        description: paragraph,
        airing: airing,
        title: title);
  }

  listEpisode(String _url) async {
    List<DetailModel> _list = new List<DetailModel>();
    final response = await get(_url);
    final document = parse(response.body);

    String episode;
    String date;
    String thumbnail;

    document.getElementsByClassName('TPost A Single').forEach((element) {
      element.getElementsByClassName('episode-list').forEach((ele) {
        thumbnail = ele.getElementsByTagName('img')[0].attributes['src'];
        episode = ele.getElementsByClassName('numerando')[0].text;
        date = ele.getElementsByClassName('date')[0].text;

        _list.add(
            DetailModel(thumbnail: thumbnail, episode: episode, date: date));
      });
    });

    return _list;
  }
}
