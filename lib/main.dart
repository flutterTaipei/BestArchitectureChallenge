import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class PostPage extends StatefulWidget {
  PostPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  static const int _sortWithId = 1;
  static const int _sortWithTitle = 2;

  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchData(_sortWithId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('使用id排序'),
                        value: _sortWithId,
                      ),
                      PopupMenuItem(
                        child: Text('使用title排序'),
                        value: _sortWithTitle,
                      )
                    ],
                onSelected: (int value) {
                  _fetchData(value);
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

  void _fetchData(int sort) async {
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    var response = await http.get(url);
    print("response=${response.body}");
    List<dynamic> result = jsonDecode(response.body);
    if (sort == _sortWithId) {
      result.sort((a, b) {
        return int.parse(a['id'].toString())
            .compareTo(int.parse(b['id'].toString()));
      });
    } else if (sort == _sortWithTitle) {
      result.sort((a, b) {
        return a['title'].toString().compareTo(b['title'].toString());
      });
    }
    setState(() {
      _posts = result;
    });
  }
}
