
import 'package:best_architecture_challenge/core/domain/fetch_post_usecase.dart';
import 'package:best_architecture_challenge/core/provider/post_api.dart';
import 'package:best_architecture_challenge/core/repository/post_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CoreInjection {

  static void init() {
    final dio = Dio();
    
    final postApi = PostApi(dio);
    final repository = PostRepositoryImpl(postApi);
    Get.lazyPut<FetchPostUseCase>(() => FetchPostUseCase(repository), fenix: true);
  }
}