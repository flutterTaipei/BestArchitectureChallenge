
import 'package:best_architecture_challenge/screens/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
