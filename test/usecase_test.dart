import 'package:best_architecture_challenge/core/domain/fetch_post_usecase.dart';
import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:best_architecture_challenge/core/repository/post_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'raw.dart';
import 'usecase_test.mocks.dart';

@GenerateMocks([PostRepositoryImpl])
void main() async {

  group('repository test', () {

    late FetchPostUseCase fetchPostUseCase;

    setUp(() {
      final mockRepo = MockPostRepositoryImpl();
      fetchPostUseCase = FetchPostUseCase(mockRepo);
      when(mockRepo.fetchPosts()).thenAnswer((_) async => Future.value(testPosts));
    });

    test('repository get post', () async {
      List<Post> posts = await fetchPostUseCase.execute(FetchPostUseCaseParams());
      expect(testPosts.length, posts.length);
      expect(testPosts[0].userId, posts[0].userId);
      expect(testPosts[0].id, posts[0].id);
      expect(testPosts[0].title, posts[0].title);
      expect(testPosts[0].body, posts[0].body);
    });
  });
}