import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:best_architecture_challenge/main.dart';
import 'widget_test.mocks.dart';

@GenerateMocks([http.Client, http.Request, http.Response])
void main() {
  final MockClient client = MockClient();

  group('fetchData', () {
    test('returns a posts if the http call completes successfully', () async {
      final postsUri = Uri.https('jsonplaceholder.typicode.com', '/posts');
      when(client.get(postsUri)).thenAnswer((_) async => http.Response(
          '[{"usetId":1,"id": 1, "title": "test", "body": "mock"}]', 200));

      expect(
          await fetchData(client, postsUri),
          jsonDecode(
              '[{"usetId":1,"id": 1, "title": "test", "body": "mock"}]'));
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      final postsUri = Uri.https('jsonplaceholder.typicode.com', '/posts');
      when(
        client.get(postsUri),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchData(client, postsUri), throwsException);
    });
  });
  group('sortPostsData', () {
    final testData = [
      {"id": 1, "body": 'zfqwe qe kqwe lqwe', "title": 'dqwes1'},
      {"id": 2, "body": 'aboeqwelqwe', "title": 'aqweqwel'},
      {"id": 3, "body": '1weqp123', "title": 'bdfwe'},
    ];
    test('sortWithId', () {
      expect(sortPostsData(SortConditionEnum.sortWithId, testData), testData);
    });
    test('sortWithBodyLength', () {
      expect(sortPostsData(SortConditionEnum.sortWithBodyLength, testData), [
        {"id": 3, "body": '1weqp123', "title": 'bdfwe'},
        {"id": 2, "body": 'aboeqwelqwe', "title": 'aqweqwel'},
        {"id": 1, "body": 'zfqwe qe kqwe lqwe', "title": 'dqwes1'},
      ]);
    });
    test('sortWithTitle', () {
      expect(
        sortPostsData(SortConditionEnum.sortWithTitle, testData),
        [
          {'id': 2, 'body': 'aboeqwelqwe', 'title': 'aqweqwel'},
          {'id': 3, 'body': '1weqp123', 'title': 'bdfwe'},
          {'id': 1, 'body': 'zfqwe qe kqwe lqwe', 'title': 'dqwes1'}
        ],
      );
    });
    test('sortWithTitleLength', () {
      expect(
        sortPostsData(SortConditionEnum.sortWithTitleLength, testData),
        [
          {'id': 3, 'body': '1weqp123', 'title': 'bdfwe'},
          {'id': 1, 'body': 'zfqwe qe kqwe lqwe', 'title': 'dqwes1'},
          {'id': 2, 'body': 'aboeqwelqwe', 'title': 'aqweqwel'},
        ],
      );
    });
  });
}
