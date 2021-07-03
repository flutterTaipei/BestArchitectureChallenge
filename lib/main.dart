import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

enum SortConditionEnum { sortWithId, sortWithTitle }

List sortData(SortConditionEnum sortConditionEnum, data) {
  if (sortConditionEnum == SortConditionEnum.sortWithId) {
    data.sort((a, b) {
      return int.parse(a['id'].toString())
          .compareTo(int.parse(b['id'].toString()));
    });
  } else if (sortConditionEnum == SortConditionEnum.sortWithTitle) {
    data.sort((a, b) {
      return a['title'].toString().compareTo(b['title'].toString());
    });
  }
  return data;
}

ValueNotifier<List> useFetchData() {
  final _data = useState([]);
  var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
  var response;

  http.get(url).then((value) {
    response = value;
    print("response=${response.body}");

    List<dynamic> result = jsonDecode(response.body);
    _data.value = result;
  });

  return _data;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: PostPage(title: 'FlutterTaipei :)'),
    );
  }
}

class PostPage extends HookWidget {
  PostPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final sortCondition =
        useState<SortConditionEnum>(SortConditionEnum.sortWithId);
    final fetchPosts = useFetchData();
    final _posts = sortData(sortCondition.value, fetchPosts.value);

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('使用id排序'),
                        value: SortConditionEnum.sortWithId,
                      ),
                      PopupMenuItem(
                        child: Text('使用title排序'),
                        value: SortConditionEnum.sortWithTitle,
                      )
                    ],
                onSelected: (SortConditionEnum value) {
                  sortCondition.value = value;
                })
          ],
        ),
        body: ListView.separated(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            String id = _posts[index]['id'].toString();
            String title = _posts[index]['title'].toString();
            String body = _posts[index]['body'].toString();
            return Container(
                padding: EdgeInsets.all(8),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: "$id. $title",
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      TextSpan(
                        text: '\n' + body,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ));
  }
}
