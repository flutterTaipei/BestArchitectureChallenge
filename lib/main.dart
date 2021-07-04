import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

enum SortConditionEnum {
  sortWithId,
  sortWithTitle,
  sortWithTitleLength,
  sortWithBodyLength
}

List sortPostsData(SortConditionEnum sortConditionEnum, data) {
  final _data = []..addAll(data);
  if (sortConditionEnum == SortConditionEnum.sortWithId) {
    _data.sort((a, b) {
      return int.parse(a['id'].toString())
          .compareTo(int.parse(b['id'].toString()));
    });
  } else if (sortConditionEnum == SortConditionEnum.sortWithTitle) {
    _data.sort((a, b) {
      return a['title'].toString().compareTo(b['title'].toString());
    });
  } else if (sortConditionEnum == SortConditionEnum.sortWithTitleLength) {
    _data.sort((a, b) {
      return a['title']
          .toString()
          .length
          .compareTo(b['title'].toString().length);
    });
  } else if (sortConditionEnum == SortConditionEnum.sortWithBodyLength) {
    _data.sort((a, b) {
      return a['body'].toString().length.compareTo(b['body'].toString().length);
    });
  }
  return _data;
}

Future<List<dynamic>> fetchData(
  http.Client client,
  Uri postsUri,
) async {
  final response = await client.get(postsUri);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);

    return result;
  } else {
    throw Exception('Failed to load posts');
  }
}

class Posts {
  final int userId;
  final int id;
  final String title;
  final String body;

  Posts(
      {required this.id,
      required this.userId,
      required this.title,
      required this.body});

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

ValueNotifier<List> useFetchPostData() {
  final _data = useState([]);
  final postsUri = Uri.https('jsonplaceholder.typicode.com', '/posts');
  final _client = http.Client();
  useEffect(() {
    fetchData(_client, postsUri).then((value) {
      _data.value = value;
    });
  }, []);

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
    final fetchPosts = useFetchPostData();
    final _posts = sortPostsData(sortCondition.value, fetchPosts.value);

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
                      ),
                      PopupMenuItem(
                        child: Text('使用title長度排序'),
                        value: SortConditionEnum.sortWithTitleLength,
                      ),
                      PopupMenuItem(
                        child: Text('使用body長度排序'),
                        value: SortConditionEnum.sortWithBodyLength,
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
