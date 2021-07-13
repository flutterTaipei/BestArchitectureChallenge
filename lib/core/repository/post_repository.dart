
import 'package:best_architecture_challenge/core/model/post.dart';

abstract class PostRepository {

  Future<List<Post>> fetchPosts();
}