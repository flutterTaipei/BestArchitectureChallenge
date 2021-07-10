// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:best_architecture_challenge/core/provider/post_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'raw.dart';

void main() {
  late PostApi postApi;

  group('request post', () {

    setUp(() {
      Dio dio = Dio();
      postApi = PostApi(dio, baseUrl: BaseUrl);
      DioAdapter dioAdapter = DioAdapter();

      dio.httpClientAdapter = dioAdapter;
      dioAdapter.onGet('/posts', (request) => request.reply(200, testPosts));
    });

    test('request posts', () async {
      final response = await postApi.getPosts();

      expect(testPosts.length, response.length);
      expect(testPosts[0].userId, response[0].userId);
      expect(testPosts[0].id, response[0].id);
      expect(testPosts[0].title, response[0].title);
      expect(testPosts[0].body, response[0].body);
    });
  });
}
