
import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:best_architecture_challenge/core/provider/post_api.dart';
import 'package:best_architecture_challenge/core/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {

  final PostApi _postApi;

  PostRepositoryImpl(this._postApi);

  @override
  Future<List<Post>> fetchPosts() {
    return _postApi.getPosts();
  }

}