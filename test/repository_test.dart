import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:best_architecture_challenge/core/provider/post_api.dart';
import 'package:best_architecture_challenge/core/repository/post_repository.dart';
import 'package:best_architecture_challenge/core/repository/post_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'raw.dart';
import 'repository_test.mocks.dart';

@GenerateMocks([PostApi])
void main() async {
  late PostRepository postRepository;

  group('repository test', () {

    PostApi postApi = MockPostApi();
    setUp(() {
      postRepository = PostRepositoryImpl(postApi);
    });

    test('repository get post', () async {
      when(postApi.getPosts()).thenAnswer((_) async => Future.value(testPosts));

      List<Post> posts = await postRepository.fetchPosts();
      expect(testPosts.length, posts.length);
      expect(testPosts[0].userId, posts[0].userId);
      expect(testPosts[0].id, posts[0].id);
      expect(testPosts[0].title, posts[0].title);
      expect(testPosts[0].body, posts[0].body);

      verify(postApi.getPosts());
      verifyNoMoreInteractions(postApi);
    });
  });
}