import 'package:best_architecture_challenge/core/domain/base_usecase.dart';
import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:best_architecture_challenge/core/repository/post_repository.dart';

//fetch_post_usecase
class FetchPostUseCase extends UseCase<PostRepository, FetchPostUseCaseParams> {
  FetchPostUseCase(PostRepository repository) : super(repository);

  @override
  void dispose() {}

  @override
  Future<List<Post>> execute(FetchPostUseCaseParams param) {
    return repository.fetchPosts();
  }

}

class FetchPostUseCaseParams {
  FetchPostUseCaseParams();
}