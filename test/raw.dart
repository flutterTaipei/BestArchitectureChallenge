import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:flutter/material.dart';

const BaseUrl = 'https://jsonplaceholder.typicode.com';

List<Post> testPosts = <Post>[
  Post(
      userId: 1,
      id: 1,
      title:
      'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
      body:
      'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto'),
  Post(
      userId: 3,
      id: 30,
      title: 'a quo magni similique perferendis',
      body:
      'alias dolor cumque\nimpedit blanditiis non eveniet odio maxime\nblanditiis amet eius quis tempora quia autem rem\na provident perspiciatis quia')
];