import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:flutter/material.dart';


class PostTile extends StatelessWidget {
  final Post item;
  final ValueChanged<Post>? onTap;

  PostTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "${item.id}. ${item.title}",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              TextSpan(
                text: '\n' + item.body,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}