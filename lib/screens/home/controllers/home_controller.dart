import 'package:best_architecture_challenge/core/domain/fetch_post_usecase.dart';
import 'package:best_architecture_challenge/core/model/post.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FetchPostUseCase _fetchPostUseCase;

  HomeController(this._fetchPostUseCase);

  final postList = <Post>[].obs;
  final _isSortByTitle = false.obs;

  @override
  void onReady() {
    _fetchPosts();
    ever<bool>(_isSortByTitle, (value) => doSortBy(value));
    super.onReady();
  }

  @override
  void onClose() {
    postList.close();
    _isSortByTitle.close();
    super.onClose();
  }

  void _fetchPosts() {
    _fetchPostUseCase.execute(FetchPostUseCaseParams()).then((value) {
      postList.clear();
      postList.addAll(value);
      update();
    }).catchError((ex) {
      print(ex);
    });
  }

  doSortBy(bool isSortByTitle) {
    if (postList.isEmpty) return;

    postList.sort((a, b) {
      if (isSortByTitle)
        return a.title.compareTo(b.title);
      else
        return a.id.compareTo(b.id);
    });
    update();
  }
}
