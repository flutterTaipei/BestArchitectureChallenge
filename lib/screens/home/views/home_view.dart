import 'package:best_architecture_challenge/screens/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SortExt on int{
  bool isSortByTitle() => this == 2;
}

//home_view
class HomeView extends GetView<HomeController> {
  static const int _sortWithId = 1;
  static const int _sortWithTitle = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterTaipei :)'),
          actions: [
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
                  controller.doSortBy(value.isSortByTitle());
                })
          ],
        ),
        body: GetBuilder<HomeController>(
          builder: (_controller) {
            return ListView.separated(
              itemCount: _controller.postList.length,
              itemBuilder: (context, index) {
                String id = _controller.postList[index].id.toString();
                String title = _controller.postList[index].title;
                String body = _controller.postList[index].body;
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
            );
          },
        )
    );
  }
}